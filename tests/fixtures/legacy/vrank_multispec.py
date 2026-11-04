import os
import json
import re
import math
from openai import OpenAI
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain.schema import HumanMessage, SystemMessage
import time
class Timer:
    def __enter__(self):
        self.start = time.time()
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        self.end = time.time()
        self.elapsed = self.end - self.start
import iverilog_call as iv
from utils_copy import postprocess_verilog_code, write_log_file
import random
import copy
import subprocess
# File-path configuration
SPEC_FILE1 = "/home/zimeng/Documents/final/DeepSpec/2.0flash5_total__spec.jsonl"#15:45---spec extractor
SPEC_FILE2 = "/home/zimeng/Documents/final/DeepSpec/2.0flash6_total__spec.jsonl"#2.0flash real graph spec
#"/home/zimeng/Documents/final/DeepSpec/data/total_merged_data.jsonl",baseline golden
#"/home/zimeng/Documents/final/DeepSpec/results_in_paper/gpt4omini/4omini_DeepSpec/all_specification_DeepSpec.jsonl"
spec_files = [
    "/home/zimeng/Documents/final/DeepSpec/2.0flashlite_extracted_specs.jsonl",
]
TESTBENCH_FILE = "/home/zimeng/Documents/final/DeepSpec/data/all_testbench.jsonl"
GOLDEN_FILE = "/home/zimeng/Documents/final/DeepSpec/data/total_merged_data.jsonl"

class RTLTester:
    def __init__(self,
                 spec_paths,
                 testbench_path,
                 golden_path,
                 output_root,
                 api_key,
                 mode="Cross_cluster_basic",
                 num_samples_per_spec=10):
        self.spec_paths = spec_paths if isinstance(spec_paths, list) else [spec_paths]
        self.testbench_path = testbench_path
        self.golden_path = golden_path
        self.output_root = output_root
        os.makedirs(output_root, exist_ok=True)
        self.api_key = api_key
        self.mode = mode
        self.num_samples_per_spec = num_samples_per_spec
        self.num_samples = len(self.spec_paths) * num_samples_per_spec

        # Load all data
        self.specs = {}
       
        self.testbenches = {}
        self.golden_data = {}
        self._load_all_data()

        # Store selected ports, simulation results and evaluations
        self.port_of_interest = {}
        self.sim_result = {}
        self.out_result = {}
        self.sim_golden = {}
        self.out_golden = {}
        self.code_evaluations = {}
        self.code_clusters = {}
        self.code_samples = {}
        self.compilation_results = {}
        self.code_evaluations_compiler_filtered = {}
        self.scenario_out_dict = {}
        self.selected_rtl_codes = {}  
        self.final_simulation_results = {}  
        self.syntax_pass_results = {}
        self.functional_pass_results = {}

    def _load_all_data(self):
        """Load all JSONL data files"""
        print("Loading data files...")
        
        # Load task specifications
       
        # Load testbenches
        with open(self.testbench_path, "r", encoding="utf-8") as f:
            for line in f:
                data = json.loads(line.strip())
                self.testbenches[data["task_id"]] = data["tb"]
        print(f"Loaded {len(self.testbenches)} testbenches")

        # Load golden-reference data
        with open(self.golden_path, "r", encoding="utf-8") as f:
            for line in f:
                data = json.loads(line.strip())
                self.golden_data[data["task_id"]] = {
                    "module_code": data["module_code"],
                    "testbench": data["testbench"],
                    "description": data["description"],
                    "header": data["header"]
                }
        print(f"Loaded {len(self.golden_data)} golden references")

        
        self.specs = {}
        for i, spec_path in enumerate(self.spec_paths):
            print(f"Loading spec file {i+1}: {spec_path}")
            with open(spec_path, "r", encoding="utf-8") as f:
                for line in f:
                    data = json.loads(line.strip())
                    task_id = data["task_id"]
                    #description = data["description"]
                    header = data.get("header", "")
                    #spec=description +header
                    spec = data["spec"]
                    if task_id not in self.specs:
                        self.specs[task_id] = []
                    self.specs[task_id].append(spec)
                    

        total_specs = sum(len(specs) for specs in self.specs.values())
        print(f"Loaded {total_specs} task specifications from {len(self.spec_paths)} spec files")
        for task_id, specs in list(self.specs.items())[:3]:  # Display statistics for the first three tasks
            print(f"  Task {task_id}: {len(specs)} specs")

        print(f"Loaded {len(self.specs)} unique tasks with specifications")

    
        # Check data consistency
        self._validate_data_consistency()

    def _validate_data_consistency(self):
        """Validate data consistency"""
        all_task_ids = set(self.specs.keys())
        testbench_ids = set(self.testbenches.keys())
        golden_ids = set(self.golden_data.keys())

        missing_testbenches = all_task_ids - testbench_ids
        missing_golden = all_task_ids - golden_ids

        if missing_testbenches:
            print(f"Warning: Missing testbenches for tasks: {missing_testbenches}")
        if missing_golden:
            print(f"Warning: Missing golden data for tasks: {missing_golden}")

        # Retain only tasks with complete data
        valid_tasks = all_task_ids & testbench_ids & golden_ids
        print(f"Valid tasks with complete data: {len(valid_tasks)}")
        
        # Filter invalid tasks
        self.specs = {k: v for k, v in self.specs.items() if k in valid_tasks}
        self.testbenches = {k: v for k, v in self.testbenches.items() if k in valid_tasks}
        self.golden_data = {k: v for k, v in self.golden_data.items() if k in valid_tasks}

    def generate_rtl(self, task_id):
        """Generate RTL code for the specified task"""
        if task_id not in self.specs:
            print(f"Error: Task {task_id} not found in specifications")
            return

        specs = self.specs[task_id]
        description = self.golden_data[task_id]["description"]
        header = self.golden_data[task_id]["header"]
        self.code_samples[task_id] = []

       
        print(f"Generating RTL samples for task {task_id} ({len(specs)} specs × {self.num_samples_per_spec} samples = {len(specs) * self.num_samples_per_spec} total)")
        sample_counter = 1
       
        # generate num = n RTLs for each spec
        for spec_idx, spec in enumerate(specs):
            print(f"  Processing spec {spec_idx + 1}/{len(specs)}")
            
            for sample_idx in range(self.num_samples_per_spec):
                task_dir = os.path.join(self.output_root, task_id, f"RTL_{sample_counter}")
                os.makedirs(task_dir, exist_ok=True)
                """
                system_msg = (
                               "You are the strongest AI in the world. "
                               "You already have the knowledge of Verilog and hardware designing. "
                               "Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you."
                           )
                       
            
                system_content = system_msg  + description  +  "The header you have already known is:" + header 
                user_content =   "\n\n" + "You can use the technical specification as follows:" + spec + "\n\nPlease only reply with the Verilog code, no other words." + "\n\nPlease always begin with `module top_module()`. "


                write_log_file(task_dir, "messages.md",
                       f"# Messages for Task: {task_id}\n\n## System Message\n\n```\n{system_content}\n```\n\n## User Message\n\n```\n{user_content}\n```\n\n")
                

                """
            
                system_msg = (
                "You are the strongest AI in the world. "
                "You already have the knowledge of Verilog and hardware designing. "
                "Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you."
                  )
                # system_content = system_msg +"\n\n" + description + "\n\n" + "The header you have already known is:" + header + "\n\n" + "Please only reply with the Verilog code after syntax check, no other words.\n" + "Please always begin with `module top_module()`."
                system_content = system_msg +"\n\n" + description + "\n\n"+ "The specification is as follows:" + "\n" + spec + "\n\n" + "Please only reply with the Verilog code after syntax check, no other words.\n" + "Please always begin with `module top_module()`."
                write_log_file(task_dir, "messages.md",
                       f"# Messages for Task: {task_id}\n\n## System Message\n\n```\n{system_content}\n```\n\n")
                 
             # Generate code
                try:
                    with Timer() as t:
                        
                        client = ChatGoogleGenerativeAI(
                            model="gemini-2.0-flash-lite",
                            api_key=os.getenv("GEMINI_API_KEY"),
                            temperature=1.0,
                            max_output_tokens=8192,
                            )
                        messages = [HumanMessage(content=system_content)]
                        resp = client.invoke(messages)
                        code = resp.content
                        code = re.sub(r'^```verilog\n', '', code)
                        code = re.sub(r'\n```$', '', code)
                        code = re.sub(r'```verilog|```', '', code)

                   
                        """ 
                        #for openai api
                        client = OpenAI(api_key=self.api_key)
                        resp = client.chat.completions.create(
                        model="gpt-4o-2024-08-06",
                        temperature=1.0,
                       #reasoning_effort="high",
                        messages=[
                           {"role": "system", "content": system_content},
                           {"role": "user", "content": user_content}
                         ]
                        )



                        code = resp.choices[-1].message.content

                        code = re.sub(r'^```verilog\n', '', code, flags=re.MULTILINE)
                        code = re.sub(r'\n```$', '', code, flags=re.MULTILINE)
                        code = re.sub(r'```verilog|```', '', code)
                        """ 
                        
                
                
                        # Save code and logs
                    with open(os.path.join(task_dir, "generation.log"), "w") as f:
                          f.write(f"Elapsed: {t.elapsed:.2f}s\n")
                          f.write(f"Model: gpt-4omini\n")
                          f.write(f"Task: {task_id}\n")
                          f.write(f"Spec: {spec_idx + 1}\n")
                          f.write(f"Sample: {sample_idx + 1}\n")
                          f.write(f"Global_Sample: {sample_counter}\n")
                
                    with open(os.path.join(task_dir, "top_module.v"), "w", encoding="utf-8") as f:
                            f.write(code)

                        # Record code-sample information
                    self.code_samples[task_id].append({
                           "sample_id": sample_counter,
                           "spec_id": spec_idx,
                           "spec_sample_id": sample_idx + 1,
                           "code": code,
                           "generation_time": t.elapsed,
                           "passed": None,
                           "compile_success": None
                           })
                
                    print(f" Generated RTL_{sample_counter} (Spec {spec_idx + 1}, Sample {sample_idx + 1}) in {t.elapsed:.2f}s")
                        
                except Exception as e:
                    print(f"    Error generating RTL_{sample_counter}: {e}")
                    # Record errors
                    with open(os.path.join(task_dir, "generation.log"), "w") as f:
                      f.write(f"Error: {e}\n")
                      f.write(f"Task: {task_id}\n")
                      f.write(f"Spec: {spec_idx + 1}\n")
                      f.write(f"Sample: {sample_idx + 1}\n")
                      f.write(f"Global_Sample: {sample_counter}\n")

                    self.code_samples[task_id].append({
                      "sample_id": sample_counter,
                      "spec_id": spec_idx,
                      "spec_sample_id": sample_idx + 1,
                      "code": "",
                      "generation_time": 0,
                      "passed": False,
                      "compile_success": False,
                      "error": str(e)
                       })
                sample_counter += 1
        print(f"Completed generating {sample_counter - 1} RTL samples for task {task_id}")

    def distribute_tb(self, task_id):
        """Distribute the testbench to each RTL directory"""
        if task_id not in self.testbenches:
            print(f"Error: No testbench found for task {task_id}")
            return
        
        testbench_content = self.testbenches[task_id]
        
        print(f"Distributing testbench for task {task_id}")
        
        # Copy the testbench to each RTL directory
        for i in range(1, self.num_samples + 1):
            rtl_dir = os.path.join(self.output_root, task_id, f"RTL_{i}")
            if os.path.exists(rtl_dir):
                tb_path = os.path.join(rtl_dir, "tb.v")
                with open(tb_path, "w", encoding="utf-8") as f:
                    f.write(testbench_content)
                print(f"Distributed testbench to RTL_{i}")



    def run_simulation(self, task_id, which="all"):
        """Run simulation tests"""
        base = os.path.join(self.output_root, task_id)
        
        if which == "all":
            dirs = [os.path.join(base, f"RTL_{i}") for i in range(1, self.num_samples+1)]
            print(f"Running simulation for all RTL samples of task {task_id}")
        elif which == "golden":
            # Golden simulation is handled by run_iverilog_simulation_on_golden
            return
        else:
            dirs = [os.path.join(base, which)]
            print(f"Running simulation for {which} of task {task_id}")
        
        for d in dirs:
            if not os.path.exists(d):
                print(f"Warning: Directory {d} does not exist")
                continue
            
            # Check whether required files exist
            required_files = ["top_module.v", "tb.v"]
            missing_files = [f for f in required_files if not os.path.exists(os.path.join(d, f))]
            if missing_files:
                print(f"Warning: Missing files in {d}: {missing_files}")
                continue
            
            try:
                # Run Icarus Verilog simulation
                print(f"Running simulation in {os.path.basename(d)}")
                all_failed = False
                # Invoke simulation directly through iverilog_call
                ivrun_info = iv.iverilog_call(d)
                
                # Save simulation-run information
                iv.save_iv_runinfo(ivrun_info, d)
                
                # Check simulation results
                success = False
                error_msg = None
                
                # Check whether TBout.txt was generated
                tbout_path = os.path.join(d, "TBout.txt")
                if os.path.exists(tbout_path):
                    with open(tbout_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                        if content.strip():
                            success = True
                            all_failed = False
                            print(f"Simulation successful, TBout.txt generated")
                        else:
                            error_msg = "TBout.txt is empty"
                else:
                    # Inspect ivrun_info for more detailed error information
                    if isinstance(ivrun_info, dict):
                        if ivrun_info.get("compile_success", False):
                            if ivrun_info.get("run_success", False):
                                success = True  # Compilation and execution both succeeded
                            else:
                                error_msg = f"Run failed: {ivrun_info.get('run_error', 'Unknown run error')}"
                        else:
                            error_msg = f"Compile failed: {ivrun_info.get('compile_error', 'Unknown compile error')}"
                    else:
                        error_msg = "TBout.txt not found and no valid ivrun_info"
                
                # Create simulation information
                info = {
                    "success": success,
                    "error": error_msg,
                    "ivrun_info": ivrun_info
                }
                
                # Save the simulation log
                with open(os.path.join(d, "sim.log"), "w") as f:
                    json.dump(info, f, indent=2)
                
                # Update compilation results
                if "RTL_" in d:
                    rtl_idx = int(os.path.basename(d).split("_")[1]) - 1
                    if task_id in self.code_samples and rtl_idx < len(self.code_samples[task_id]):
                        self.code_samples[task_id][rtl_idx]["compile_success"] = success
                        if not success:
                            self.code_samples[task_id][rtl_idx]["compile_error"] = error_msg
                
                print(f"Simulation completed: {'Success' if success else 'Failed'}")
                if error_msg:
                    print(f"Error details: {error_msg}")
                
            except Exception as e:
                print(f"Error running simulation in {d}: {e}")
                # Record errors
                error_info = {"success": False, "error": str(e)}
                with open(os.path.join(d, "sim.log"), "w") as f:
                    json.dump(error_info, f, indent=2)
        if all_failed:
            print(f"All simulations failed for task {task_id} in directories: {dirs}")
            self.syntax_pass_results[task_id] = False
            self.functional_pass_results[task_id] = False
        

    def extract_output_sequence_dict(self, directory_path):
        """Extract output sequences from TBout.txt using the golden-method implementation as a reference"""
        tbout_path = os.path.join(directory_path, "TBout.txt")
        if not os.path.exists(tbout_path):
            print(f"Warning: TBout.txt not found in {directory_path}")
            return []
        
        try:
            with open(tbout_path, 'r', encoding='utf-8') as f:
                lines = f.readlines()
        except Exception as e:
            print(f"Error reading TBout.txt in {directory_path}: {e}")
            return []
        
        # Check for the [check] prefix
        contains_check_prefix = any(line.startswith("[check]") for line in lines)
        
        output_sequence = []
        
        for line in lines:
            line = line.strip()
            if not line:
                continue
            
            # If a [check] prefix exists, process only prefixed lines
            if contains_check_prefix and not line.startswith("[check]"):
                continue
            
            # Remove the [check] prefix
            if line.startswith("[check]"):
                line = line[len("[check]"):].strip()
            
            # Parse line contents
            parts = [p.strip() for p in line.split(",")]
            values = {}
            
            for part in parts:
                if not part:
                    continue
                
                if "scenario" in part:
                    try:
                        values["scenario"] = int(part.split(":")[1].strip())
                    except (ValueError, IndexError):
                        continue
                elif "=" in part:
                    try:
                        key, val = part.split("=", 1)
                        key = key.strip()
                        val = val.strip()
                        
                        # Try integer conversion, skipping X/Z values
                        if val.isdigit():
                            values[key] = int(val)
                        elif val.lower() not in ["x", "z"]:
                            try:
                                values[key] = int(val)
                            except ValueError:
                                values[key] = val
                        else:
                            values[key] = val
                    except ValueError:
                        continue
            
            if "scenario" in values:
                output_sequence.append(values)
        
        return output_sequence

    def debug_simulation_output(self, task_id):
      """Debug simulation output by checking generated files"""
      base = os.path.join(self.output_root, task_id)
    
      print(f"Debugging simulation output for task {task_id}")
    
      # Check output from all RTL directories
      for i in range(1, self.num_samples + 1):
        rtl_dir = os.path.join(base, f"RTL_{i}")
        if os.path.exists(rtl_dir):
            print(f"\nRTL_{i} simulation output:")
            
            # Check possible output files
            output_files = ["TBout.txt", "output.txt", "result.txt", "dump.vcd"]
            for output_file in output_files:
                file_path = os.path.join(rtl_dir, output_file)
                if os.path.exists(file_path):
                    file_size = os.path.getsize(file_path)
                    print(f"  {output_file}: {file_size} bytes")
                    
                    # Preview the content of text files
                    if output_file.endswith('.txt'):
                        try:
                            with open(file_path, 'r', encoding='utf-8') as f:
                                content = f.read()
                                print(f"    Content preview: {content[:200]}...")
                        except Exception as e:
                            print(f"    Error reading file: {e}")
            
            # Check the simulation log
            sim_log = os.path.join(rtl_dir, "sim.log")
            if os.path.exists(sim_log):
                try:
                    with open(sim_log, 'r') as f:
                        log_content = json.load(f)
                        print(f"  Simulation log: {log_content}")
                except Exception as e:
                    print(f"  Error reading sim.log: {e}")
    
     

    def extract_output_sequence_dict(self, directory_path):
        """Extract output sequences from TBout.txt"""
        tbout_path = os.path.join(directory_path, "TBout.txt")
        if not os.path.exists(tbout_path):
            print(f"Warning: TBout.txt not found in {directory_path}")
            return []
        
        try:
            with open(tbout_path, 'r', encoding='utf-8') as f:
                lines = f.read().splitlines()
        except Exception as e:
            print(f"Error reading TBout.txt in {directory_path}: {e}")
            return []
        
        has_check = any(l.startswith("[check]") for l in lines)
        seq = []
        
        for ln in lines:
            if not ln.strip():
                continue
            
            if has_check and not ln.startswith("[check]"):
                continue
            
            if ln.startswith("[check]"):
                ln = ln[len("[check]"):].strip()
            
            # Parse line contents
            parts = [p.strip() for p in ln.split(",")]
            rec = {}
            
            for p in parts:
                if not p:
                    continue
                if p.startswith("scenario"):
                    try:
                        rec["scenario"] = int(p.split(":")[1])
                    except:
                        continue
                elif "=" in p:
                    try:
                        k, v = p.split("=", 1)
                        v = v.strip()
                        # Try integer conversion, skipping X/Z values
                        if all(c not in v.lower() for c in "xz"):
                            try:
                                v = int(v)
                            except:
                                pass
                        rec[k.strip()] = v
                    except:
                        continue
            
            if "scenario" in rec:
                seq.append(rec)
        
        return seq

    def extract_port_of_interest(self, task_id):
        """Extract output ports of interest"""
        code_path = os.path.join(self.output_root, task_id, "RTL_1", "top_module.v")
        if not os.path.exists(code_path):
            print(f"Warning: Cannot find RTL_1 for task {task_id}")
            self.port_of_interest[task_id] = []
            return
        
        try:
            with open(code_path, 'r', encoding='utf-8') as f:
                code = f.read()
        except Exception as e:
            print(f"Error reading code for task {task_id}: {e}")
            self.port_of_interest[task_id] = []
            return
        
        ports = []
        in_module = False
        
        for line in code.splitlines():
            line = line.strip()
            
            # Detect the start of the module declaration
            if line.startswith("module "):
                in_module = True
                continue
            
            # Detect the end of the module declaration
            if in_module and line.startswith(");"):
                break
            
            # Extract output ports
            if in_module and line.startswith("output"):
                # Remove the output keyword
                port_line = line[6:].strip()
                
                # Handle an optional bit-width declaration
                if port_line.startswith("["):
                    # Find the end of the bit-width declaration
                    bracket_end = port_line.find("]")
                    if bracket_end != -1:
                        port_line = port_line[bracket_end+1:].strip()
                
                # Split multiple ports
                for part in port_line.split(","):
                    port_name = part.strip().rstrip(";").rstrip(")")
                    if port_name and port_name not in ports:
                        ports.append(port_name)
        
        self.port_of_interest[task_id] = ports
        print(f"Extracted {len(ports)} output ports for task {task_id}: {ports}")

    def filter_labelfree(self, seq, task_id):
        """Filter output sequences to retain ports of interest"""
        if not seq:
            return []
        
        ports = self.port_of_interest.get(task_id, [])
        out = []
        
        for rec in seq:
            row = [rec.get("scenario", 0)]
            for p in ports:
                row.append(rec.get(p, None))
            out.append(row)
        
        return out

    def analyze_task(self, task_id):
        """Analyze task results"""
        base = os.path.join(self.output_root, task_id)
        self.sim_result[task_id] = []
        self.out_result[task_id] = []
        
        print(f"Analyzing results for task {task_id}")
        
        # Analyze each RTL sample
        for i in range(1, self.num_samples+1):
            rtl_dir = os.path.join(base, f"RTL_{i}")
            seq = self.extract_output_sequence_dict(rtl_dir)
            self.sim_result[task_id].append(seq)
            self.out_result[task_id].append(self.filter_labelfree(seq, task_id))
        
        # Analyze golden-reference results
        golden_dir = os.path.join(base, "golden_sim")
        if os.path.exists(golden_dir):
          seqg = self.extract_output_sequence_dict(golden_dir)
          self.sim_golden[task_id] = seqg
          self.out_golden[task_id] = self.filter_labelfree(seqg, task_id)
        else:
          print(f"Golden sim directory not found for task {task_id}, skipping golden analysis")
          self.sim_golden[task_id] = []
          self.out_golden[task_id] = []
    
        # Update passed status and result fields in code_samples
        if task_id in self.code_samples:
          for i in range(min(len(self.code_samples[task_id]), len(self.out_result[task_id]))):
            # Check whether compilation succeeded
            compile_success = self.code_samples[task_id][i].get("compile_success", False)
            
            # Check for runtime errors
            has_runtime_error = self.code_samples[task_id][i].get("has_runtime_error", False)
            
            # Only samples that compile without runtime errors count as passed
            passed = compile_success and not has_runtime_error
            
            # Update passed status
            self.code_samples[task_id][i]["passed"] = passed
            
            # Set the result field for compatibility
            self.code_samples[task_id][i]["result"] = "passed" if passed else "failed"
    
        # Prepare data for cluster scoring
        self.scenario_out_dict[task_id] = self.out_result[task_id]
    
        print(f"Analysis completed for task {task_id}")

    def evaluate_samples(self):
        """
        Evaluate sample quality in Cross_cluster_basic mode
        """
        if self.mode == "Cross_cluster_basic":
            # Initialize evaluation scores for each task
            for task_id, code_data in self.code_samples.items():
                self.code_evaluations[task_id] = [0] * self.num_samples

                # Initialize the dictionary that stores clusters
                clusters = {}
                for attempt, data in enumerate(code_data):
                    if attempt >= self.num_samples:
                        break
                    
                    # Check whether output-sequence data exists
                    if task_id not in self.scenario_out_dict:
                        continue
                    
                    output_sequence = self.scenario_out_dict[task_id][attempt]
                    
                    # Skip empty output sequences
                    if not output_sequence:
                        continue

                    # Convert output sequences to tuples for use as dictionary keys
                    output_tuple = tuple(tuple(output) for output in output_sequence)
                    
                    # Add the sequence to its cluster
                    if output_tuple in clusters:
                        clusters[output_tuple].append(attempt)
                    else:
                        clusters[output_tuple] = [attempt]
                    
                    """
                    # Sort samples within each cluster by passed status and random noise
                    clusters[output_tuple].sort(
                        key=lambda x: (self.code_samples[task_id][x]["result"]=="passed") + random.gauss(0, 3),
                        reverse=True
                    )
                    """
                
                    clusters[output_tuple].sort(
                     key=lambda x: (
                       -int(self.code_samples[task_id][x].get("passed", False)),  # Passed samples first
                      x  # Use sample index for consistent ordering
                      )
                         )
                # Calculate each cluster's score
                for cluster, attempts in clusters.items():
                    cluster_size = len(attempts)
                    
                    # Assign the cluster score to every sample in that cluster
                    for attempt in attempts:
                        self.code_evaluations[task_id][attempt] = cluster_size
                
                # Store clusters and sort them by highest evaluation score
                self.code_clusters[task_id] = clusters
                sorted_clusters = sorted(
                    clusters.items(),
                     key=lambda item: (
                     len(item[1]),  # Cluster size
                     sum(1 for idx in item[1] if self.code_samples[task_id][idx].get("passed", False)),  # Number of passed samples
                     -min(item[1])  # Prefer the smallest sample index
                            ),
                      reverse=True
                          )
                
                """
                self.code_clusters[task_id] = {
                    k: v for k, v in sorted(
                        self.code_clusters[task_id].items(), 
                        key=lambda item: max(self.code_evaluations[task_id][idx] for idx in item[1]), 
                        reverse=True
                    )
                }
                """
        else:
            raise ValueError(f"Invalid mode: {self.mode}")
        
    def select_best_rtl_from_clusters(self, task_id):
        """
        Select the best RTL code from the clusters
        """
        if task_id not in self.code_clusters or not self.code_clusters[task_id]:
           print(f"Warning: Empty clusters for task {task_id}, selecting random compiled-success RTL")
           
           task_dir = os.path.join(self.output_root, task_id)
           if not os.path.exists(task_dir):
            print(f"Error: Task directory {task_dir} does not exist")
            self.syntax_pass_results[task_id] = False
            self.functional_pass_results[task_id] = False
            self.final_simulation_results[task_id] = {
                "syntax_pass": False,
                "functional_pass": False,
                "final_golden_pass": False,
                "selected_sample_idx": None,
                "cluster_size": 0,
                "original_passed": False
             }
            return None  
           

           passed_rtl_dirs = []
           for i in range(1, self.num_samples + 1):
             rtl_dir = os.path.join(task_dir, f"RTL_{i}")
             run_info_path = os.path.join(task_dir, f"RTL_{i}run_info.txt")
             if os.path.exists(run_info_path):
                with open(run_info_path, "r", encoding="utf-8") as f:
                    content = f.read()
                    if "iverilog simulation passed!" in content:
                        passed_rtl_dirs.append(rtl_dir)
           if passed_rtl_dirs:
            # Randomly select a sample that compiled
             selected_dir = random.choice(passed_rtl_dirs)
             rtl_idx = int(os.path.basename(selected_dir).split("_")[1]) - 1
             top_module_path = os.path.join(selected_dir, "top_module.v")
             if os.path.exists(top_module_path):
                with open(top_module_path, "r", encoding="utf-8") as f:
                    best_rtl_code = f.read()
                    
                print(f"Randomly selected RTL from compiled samples for task {task_id}: sample {rtl_idx + 1}")
                self.selected_rtl_codes[task_id] = {
                    "code": best_rtl_code,
                    "sample_idx": rtl_idx,
                    "cluster_size": 1,  # A randomly selected sample belongs to no cluster; use size 1
                    "original_passed": self.code_samples[task_id][rtl_idx].get("passed", False)
                }
                return best_rtl_code
           print(f"Error: No compiled samples found for task {task_id}")
           self.syntax_pass_results[task_id] = False
           self.functional_pass_results[task_id] = False
           self.final_simulation_results[task_id] = {
            "syntax_pass": False,
            "functional_pass": False,
            "final_golden_pass": False,
            "selected_sample_idx": None,
            "cluster_size": 0,
            "original_passed": False
              }
           return None
              
             
           
        clusters = self.code_clusters[task_id]
        if not clusters:
            print(f"Error: Clusters dictionary is empty for task {task_id}")
            self.syntax_pass_results[task_id] = False
            self.functional_pass_results[task_id] = False
            self.final_simulation_results[task_id] = {
            "syntax_pass": False,
            "functional_pass": False,
            "final_golden_pass": False,
            "selected_sample_idx": None,
            "cluster_size": 0,
            "original_passed": False
            }
            return None
      
        # Get the highest-scoring cluster
        best_cluster_key = list(clusters.keys())[0]  # Already sorted by score
        best_cluster_samples = clusters[best_cluster_key]
        
        if not best_cluster_samples:
         print(f"Error: Best cluster is empty for task {task_id}")
         self.syntax_pass_results[task_id] = False
         self.functional_pass_results[task_id] = False
         self.final_simulation_results[task_id] = {
            "syntax_pass": False,
            "functional_pass": False,
            "final_golden_pass": False,
            "selected_sample_idx": None,
            "cluster_size": 0,
            "original_passed": False
         }
         return None
        

        # Select the first sample in the best cluster, already ordered by passed status
        best_sample_idx = best_cluster_samples[0]
        if (task_id not in self.code_samples or 
          best_sample_idx >= len(self.code_samples[task_id]) or
          not isinstance(self.code_samples[task_id][best_sample_idx], dict)):
          print(f"Error: Invalid sample index {best_sample_idx} for task {task_id}")
          self.syntax_pass_results[task_id] = False
          self.functional_pass_results[task_id] = False
          self.final_simulation_results[task_id] = {
            "syntax_pass": False,
            "functional_pass": False,
            "final_golden_pass": False,
            "selected_sample_idx": None,
            "cluster_size": 0,
            "original_passed": False
          }
          return None
    
        best_rtl_code = self.code_samples[task_id][best_sample_idx]["code"]
        
        print(f"Selected RTL from cluster for task {task_id}: sample {best_sample_idx + 1}")
        print(f"Cluster size: {len(best_cluster_samples)}")
        print(f"Sample passed: {self.code_samples[task_id][best_sample_idx].get('passed', False)}")
        
        self.selected_rtl_codes[task_id] = {
            "code": best_rtl_code,
            "sample_idx": best_sample_idx,
            "cluster_size": len(best_cluster_samples),
            "original_passed": self.code_samples[task_id][best_sample_idx].get("passed", False)
        }
        
        return best_rtl_code
      
    def run_final_simulation_with_golden_testbench(self, task_id):
        """
        Run the final simulation of selected RTL against the golden testbench
        """
        if task_id not in self.selected_rtl_codes:
            print(f"Error: No selected RTL code for task {task_id}")
            self.syntax_pass_results[task_id] = False
            self.functional_pass_results[task_id] = False
            return False, False
        
        if task_id not in self.golden_data:
            print(f"Error: No golden data found for task {task_id}")
            self.syntax_pass_results[task_id] = False
            self.functional_pass_results[task_id] = False
            return False, False
        
        rtl_code = self.selected_rtl_codes[task_id]["code"]
        golden_testbench = self.golden_data[task_id]["testbench"]
        
        # Create the final_golden_sim directory
        final_sim_dir = os.path.join(self.output_root, task_id, "final_golden_sim")
        os.makedirs(final_sim_dir, exist_ok=True)
        
        # Write the selected RTL code
        with open(os.path.join(final_sim_dir, "top_module.v"), "w", encoding="utf-8") as f:
            f.write(rtl_code)
        
        # Write the golden testbench
        with open(os.path.join(final_sim_dir, "tb.v"), "w", encoding="utf-8") as f:
            f.write(golden_testbench)
        
        print(f"Running final simulation with golden testbench for task {task_id}")
        orig_dir = os.getcwd()
        syntax_pass = False
        functional_pass = False

        try:
             os.chdir(final_sim_dir)
             if os.path.exists("tb.v"):
              # Compilation command
               compile_cmd = ["iverilog", "-g2012", "-o", "sim.vvp", "top_module.v", "tb.v"]
               compile_result = subprocess.run(
                compile_cmd, 
                capture_output=True, 
                text=True
                )
               with open("compile_log.txt", "w") as log_file:
                 log_file.write(compile_result.stdout)
                 log_file.write(compile_result.stderr)

               if compile_result.returncode == 0:
                 syntax_pass = True
                 print("Compilation successful, running simulation...")

                 # Simulation command
                 sim_cmd = ["vvp", "sim.vvp"]
                 sim_result = subprocess.run(
                    sim_cmd, 
                    capture_output=True, 
                    text=True,
                    timeout=30  
                 )
                 with open("simulation_log.txt", "w") as log_file:
                    log_file.write(sim_result.stdout)
                    log_file.write(sim_result.stderr)

                 if sim_result.returncode == 0:
                    print(f"Simulation for task {task_id} completed successfully!")
                    with open("test_result.txt", "w") as result_file:
                        result_file.write("PASS: Simulation completed without errors\n")
                        result_file.write("\nSimulation Output:\n")
                        result_file.write(sim_result.stdout)


                    with open("test_result.txt", "r") as f:
                        content = f.read() 

                    if "PASS: Simulation completed without errors" in content:
                        syntax_pass = True
                    
                    # Functional success criterion: the file contains "Mismatches: 0"
                    if "Mismatches: 0" in content:
                        functional_pass = True
                 else:
                    print(f"Simulation for task {task_id} failed with errors")
                    with open("test_result.txt", "w") as result_file:
                        result_file.write("FAIL: Simulation returned errors\n")
                        result_file.write("\nError Output:\n")
                        result_file.write(sim_result.stderr)
                    syntax_pass = False
                    functional_pass = False
               else:
                   print(f"Compilation for task {task_id} failed")
                   with open("test_result.txt", "w") as result_file:
                     result_file.write("FAIL: Compilation failed\n")
                     result_file.write("\nCompilation Errors:\n")
                     result_file.write(compile_result.stderr)
                     syntax_pass = False
                     functional_pass = False
             else:
                 print(f"No testbench (tb.v) found for task {task_id}, skipping simulation")
                 with open("test_result.txt", "w") as result_file:
                   result_file.write("SKIP: No testbench available\n")

        except Exception as e:
            print(f"Error during simulation for task {task_id}: {str(e)}")
            with open(os.path.join(final_sim_dir, "test_result.txt"), "w") as result_file:
              result_file.write(f"ERROR: Test execution failed\n{str(e)}\n") 
            with open(os.path.join(final_sim_dir, "error_log.txt"), "a") as f:
               f.write(f"Simulation/Compilation error: {str(e)}\n")
            syntax_pass = False
            functional_pass = False
        finally:
           os.chdir(orig_dir)

        # Save results
        self.syntax_pass_results[task_id] = syntax_pass
        self.functional_pass_results[task_id] = functional_pass

        final_sim_info = {
        "syntax_pass": syntax_pass,
        "functional_pass": functional_pass,
        "selected_sample_idx": self.selected_rtl_codes[task_id]["sample_idx"],
        "cluster_size": self.selected_rtl_codes[task_id]["cluster_size"],
        "original_passed": self.selected_rtl_codes[task_id]["original_passed"]
        }
        with open(os.path.join(final_sim_dir, "final_results.log"), "w") as f:
          json.dump(final_sim_info, f, indent=2)

        self.final_simulation_results[task_id] = final_sim_info
        
        status = []
        if syntax_pass: status.append("Syntax passed")
        if functional_pass: status.append("Functionality passed")
        if not status: status.append("Not passed")
        status_str = ", ".join(status)
        print(f"Task {task_id}: Status={status_str}")
        
        return syntax_pass, functional_pass
        
        
      
    def calculate_final_metrics(self, task_id):
        """
        Calculate final evaluation metrics
        """
        if task_id not in self.final_simulation_results or task_id not in self.code_clusters:
            return {
                "baseline_pass1": 0.0,
                "cluster_pass1": 0.0,
                "final_golden_pass": False,
                "improvement": 0.0
            }
        
        baseline_pass1 = self.passk_baseline(task_id, 1)
        cluster_pass1 = self.passk_with_our_evaluation_only(1)
        syntax_pass = self.final_simulation_results[task_id].get("syntax_pass", False)
        functional_pass = self.final_simulation_results[task_id].get("functional_pass", False)
        final_passed = syntax_pass and functional_pass
        
        # Calculate improvement
        improvement = 1.0 if final_passed else 0.0
        
        if self.final_simulation_results[task_id].get("selected_sample_idx") is None:
          return {
            "baseline_pass1": baseline_pass1,
            "cluster_pass1": cluster_pass1,
            "syntax_pass": False,
            "functional_pass": False,
            "final_golden_pass": False,
            "improvement": 0.0,
            "selected_sample": None,
            "cluster_size": 0
            }
        return {
        "baseline_pass1": baseline_pass1,
        "cluster_pass1": cluster_pass1,
        "syntax_pass": syntax_pass,
        "functional_pass": functional_pass,
        "final_golden_pass": final_passed,
        "improvement": improvement,
        "selected_sample": self.final_simulation_results[task_id]["selected_sample_idx"] + 1,
        "cluster_size": self.final_simulation_results[task_id]["cluster_size"]
    }
    def passk_with_our_evaluation_only(self, k, mode="Cross_cluster_basic"):
       
        # Deep-copy evaluations and filter samples that failed compilation
        evals = copy.deepcopy(self.code_evaluations)
        for task_id in evals:
            for i, data in enumerate(self.code_samples[task_id]):
                if i >= self.num_samples:
                    break
                if not data.get("passed", False):
                    evals[task_id][i] = float('-inf')  # Exclude samples that failed compilation
        
        results = []
        for task_id, samples in self.code_samples.items():
            # Skip tasks with no valid samples
            valid_indices = [i for i in range(min(self.num_samples, len(samples))) if evals[task_id][i] > float('-inf')]
            if not valid_indices:
                results.append(0.0)
                continue
            
            # Sort clusters by highest evaluation score
            clusters = self.code_clusters[task_id]
            sorted_clusters = sorted(
                clusters.values(),
                key=lambda idxs: max(evals[task_id][i] for i in idxs),
                reverse=True
            )
            
            # Collect at most k clusters
            selected_fail_probs = []
            taken = 0
            for cluster in sorted_clusters:
                if taken >= k:
                    break
                # Count valid and failed samples in each cluster
                valid = [i for i in cluster if evals[task_id][i] > float('-inf')]
                if not valid:
                    continue
                fails = sum(1 for i in valid if not samples[i]["passed"])
                selected_fail_probs.append(fails / len(valid))
                taken += 1
            
            # Estimate the remaining failure probability if fewer than k clusters exist
            if taken < k:
                # Samples remaining after selecting one from each cluster
                used = {i for cl in sorted_clusters[:taken] for i in cl}
                remaining = [i for i in valid_indices if i not in used]
                m = k - taken
                # Probability that all remaining m samples fail
                fails = sum(1 for i in remaining if not samples[i]["passed"])
                total = len(remaining)
                if total < m or fails == 0:
                    rem_fail_prob = 0.0
                else:
                    rem_fail_prob = math.comb(fails, m) / math.comb(total, m)
                selected_fail_probs.append(rem_fail_prob)
            
            # Overall success rate = 1 - product of all failure probabilities
            success = 1 - math.prod(selected_fail_probs)
            results.append(success)
        
        # Average over all tasks
        return sum(results) / len(results)

    def passk_baseline(self, task_id, k=1):
        
        if task_id not in self.code_samples:
            return 0.0
        
        code_data = self.code_samples[task_id]
        # Consider only samples that compiled
        valid_samples = [data for data in code_data if data.get("compile_success", False)]
        
        if not valid_samples:
            return 0.0
        
        pass_c = sum(1 for data in valid_samples if data.get("passed", False))
        pass_n = len(valid_samples)
        
        if pass_n == 0 or pass_c == 0:
            return 0.0
        
        if k > pass_n:
            k = pass_n
        
        # Use the combinatorial formula to calculate pass@k
        try:
            success_rate = 1 - math.comb(pass_n - pass_c, k) / math.comb(pass_n, k)
        except:
            success_rate = pass_c / pass_n

        return success_rate
    

    def run_full_pipeline(self, task_id):
     """Run the complete test pipeline (modified version)"""
     print(f"\n{'='*50}")
     print(f"Processing task: {task_id}")
     print(f"{'='*50}")
    
     try:
        # 1. Generate RTL code
        print("Step 1: Generating RTL codes...")
        self.generate_rtl(task_id)
        time.sleep(2)  # Allow the filesystem to settle
        
        # 2. Distribute testbenches
        print("Step 2: Distributing testbenches...")
        self.distribute_tb(task_id)
        
        # 3. Run initial simulations with the distributed testbenches
        print("Step 3: Running initial simulations...")
        self.run_simulation(task_id, "all")
        
        # 4. Extract ports of interest
        print("Step 4: Extracting ports of interest...")
        self.extract_port_of_interest(task_id)
        
        # 5. Analyze results
        print("Step 5: Analyzing results...")
        self.analyze_task(task_id)
        
        # 6. Evaluate samples and form clusters
        print("Step 6: Evaluating samples and clustering...")
        self.evaluate_samples()
        
        # 7. Select the best RTL code from the clusters
        print("Step 7: Selecting best RTL from clusters...")
        selected_rtl = self.select_best_rtl_from_clusters(task_id)
        
        # Handle cases where no best RTL code can be selected
        if selected_rtl is None:
            print("Warning: No RTL code selected from clusters") 
            metrics = self.calculate_final_metrics(task_id)
            
            # Report result statistics even when no best RTL was selected
            if task_id in self.code_samples:
                total_samples = len(self.code_samples[task_id])
                compiled_samples = sum(1 for s in self.code_samples[task_id] if s.get("compile_success", False))
                passed_samples = sum(1 for s in self.code_samples[task_id] if s.get("passed", False))
                
                print(f"\nResults for {task_id}:")
                print(f"Total samples: {total_samples}")
                print(f"Compiled successfully: {compiled_samples}")
                print(f"Passed initial tests: {passed_samples}")
                print(f"Baseline pass@1: {metrics['baseline_pass1']:.3f}")
                print(f"Cluster pass@1: {metrics['cluster_pass1']:.3f}")
                print(f"Selected sample: None (cluster size: 0)")
                print(f"Golden testbench - Syntax: FAILED")
                print(f"Golden testbench - Functional: FAILED")
                print(f"Final golden test: FAILED")
            
            return metrics
        else:
            # Continue the normal workflow
            # 8. Run the final golden-testbench simulation for the selected RTL
            print("Step 8: Running final simulation with golden testbench...")
            final_result = self.run_final_simulation_with_golden_testbench(task_id)

            # 9. Calculate final metrics
            print("Step 9: Calculating final metrics...")
            metrics = self.calculate_final_metrics(task_id)

            # 10. Report result statistics
            if task_id in self.code_samples:
                total_samples = len(self.code_samples[task_id])
                compiled_samples = sum(1 for s in self.code_samples[task_id] if s.get("compile_success", False))
                passed_samples = sum(1 for s in self.code_samples[task_id] if s.get("passed", False))
                
                print(f"\nResults for {task_id}:")
                print(f"Total samples: {total_samples}")
                print(f"Compiled successfully: {compiled_samples}")
                print(f"Passed initial tests: {passed_samples}")
                print(f"Baseline pass@1: {metrics['baseline_pass1']:.3f}")
                print(f"Cluster pass@1: {metrics['cluster_pass1']:.3f}")
                print(f"Selected sample: {metrics.get('selected_sample', 'None')} (cluster size: {metrics.get('cluster_size', 0)})")
                print(f"Golden testbench - Syntax: {'PASSED' if metrics.get('syntax_pass', False) else 'FAILED'}")
                print(f"Golden testbench - Functional: {'PASSED' if metrics.get('functional_pass', False) else 'FAILED'}")
                print(f"Final golden test: {'PASSED' if metrics.get('final_golden_pass', False) else 'FAILED'}")

            return metrics
    
     except Exception as e:
        print(f"Error processing task {task_id}: {e}")
        import traceback
        traceback.print_exc()
        self.syntax_pass_results[task_id] = False
        self.functional_pass_results[task_id] = False
        return self.calculate_final_metrics(task_id)

    def run_all_tasks(self):
        """Run all tasks (modified version)"""
        results = {}
        
        for task_id in self.specs:
            result = self.run_full_pipeline(task_id)
            results[task_id] = result
        
        # Summarize results
        print(f"\n{'='*60}")
        print("SUMMARY RESULTS")
        print(f"{'='*60}")
        
        total_tasks = len(results)
        syntax_pass_count = sum(1 for r in results.values() if r["syntax_pass"])
        functional_pass_count = sum(1 for r in results.values() if r["functional_pass"])
        final_pass_count = sum(1 for r in results.values() if r["final_golden_pass"])
        
        baseline_avg = sum(r["baseline_pass1"] for r in results.values()) / total_tasks if total_tasks > 0 else 0
        cluster_avg = sum(r["cluster_pass1"] for r in results.values()) / total_tasks if total_tasks > 0 else 0
        
        
        print(f"Total tasks: {total_tasks}")
        print(f"Syntax pass: {syntax_pass_count}/{total_tasks} ({syntax_pass_count/total_tasks:.3f})")
        print(f"Functional pass: {functional_pass_count}/{total_tasks} ({functional_pass_count/total_tasks:.3f})")
        print(f"Final golden tests passed: {final_pass_count}/{total_tasks} ({final_pass_count/total_tasks:.3f})")
        print(f"Average baseline pass@1: {baseline_avg:.3f}")
        print(f"Average cluster pass@1: {cluster_avg:.3f}")
        
        # Detailed results
        print(f"\nDetailed results:")
        print(f"{'Task':<15} {'Baseline':<10} {'Cluster':<10} {'Final':<10} {'Selected':<10} {'ClusterSize':<12}")
        print("-" * 70)

        for task_id, metrics in sorted(results.items()):
            syntax_status = "PASS" if metrics["syntax_pass"] else "FAIL"
            functional_status = "PASS" if metrics["functional_pass"] else "FAIL"
            final_status = "PASS" if metrics["final_golden_pass"] else "FAIL"
            
            selected_sample = metrics.get("selected_sample", "None")
            cluster_size = metrics.get("cluster_size", 0)
            
            print(f"{task_id:<15} {metrics['baseline_pass1']:<10.3f} {metrics['cluster_pass1']:<10.3f} "
                  f"{syntax_status:<8} {functional_status:<11} {final_status:<8} "
                  f"{selected_sample!s:<10} {cluster_size:<12}")
    
        return results

    
def debug_final_simulation(self, task_id):
    """Debug final simulation results"""
    if task_id not in self.final_simulation_results:
        print(f"No final simulation results for task {task_id}")
        return
    
    result = self.final_simulation_results[task_id]
    final_sim_dir = os.path.join(self.output_root, task_id, "final_golden_sim")
    
    print(f"\nFinal simulation debug for task {task_id}:")
    print(f"Directory: {final_sim_dir}")
    print(f"Syntax pass: {result.get('syntax_pass', False)}")
    print(f"Functional pass: {result.get('functional_pass', False)}")
    print(f"Final passed: {result.get('final_passed', False)}")
    print(f"Selected sample: {result['selected_sample_idx'] + 1}")
    print(f"Cluster size: {result['cluster_size']}")
    print(f"Original passed: {result['original_passed']}")
    
    if result.get('error'):
        print(f"Error: {result['error']}")
    
    # Check output files
    if os.path.exists(final_sim_dir):
        files = os.listdir(final_sim_dir)
        print(f"Files in directory: {files}")
        
        # Check final_results.log
        final_results_path = os.path.join(final_sim_dir, "final_results.log")
        if os.path.exists(final_results_path):
            with open(final_results_path, 'r', encoding='utf-8') as f:
                final_results = json.load(f)
                print(f"Final results log: {final_results}")
        
        # Check TBout.txt
        tbout_path = os.path.join(final_sim_dir, "TBout.txt")
        if os.path.exists(tbout_path):
            with open(tbout_path, 'r', encoding='utf-8') as f:
                content = f.read()
                print(f"TBout.txt content ({len(content)} chars):")
                print(content[:500] + "..." if len(content) > 500 else content)
        
        # Check final_sim.log
        final_sim_log_path = os.path.join(final_sim_dir, "final_sim.log")
        if os.path.exists(final_sim_log_path):
            with open(final_sim_log_path, 'r', encoding='utf-8') as f:
                sim_log = json.load(f)
                print(f"Final sim log: {sim_log}")

# Usage example
if __name__ == "__main__":
    # Check API keys
    api_key = os.getenv("OPENAI_API_KEY")

    if not api_key:
        print("Error: OPENAI_API_KEY environment variable not set")
        exit(1)
    
    
    tester = RTLTester(
        spec_paths=spec_files,
        testbench_path=TESTBENCH_FILE,
        golden_path=GOLDEN_FILE,
        output_root="2.0flashlite_dv/",
        api_key=api_key,
        mode="Cross_cluster_basic",
        num_samples_per_spec=10,
    )
    
    # Run all tasks
    results = tester.run_all_tasks()