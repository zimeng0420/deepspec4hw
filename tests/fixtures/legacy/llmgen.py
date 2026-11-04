# Successful execution validates the new tools; the version without the copy suffix can then be removed
import os
import json, sys, subprocess, logging
import datetime
import re
import time
import uuid
from openai import OpenAI
from tenacity import retry, wait_fixed, stop_after_attempt, retry_if_exception_type
import requests.exceptions
import threading
from concurrent.futures import ThreadPoolExecutor, as_completed
import numpy as np

from dotenv import load_dotenv
from langchain_core.messages import AIMessage, HumanMessage
from langchain_google_genai import ChatGoogleGenerativeAI
import sys
sys.path.insert(0, "/home/zimeng/Documents/final/DeepSpec/backend/src")

from agent.utils_copy import (
    log_task_result,
    run_simulation_test,
    write_log_file,
    analyze_task_results,
    initialize_cost_tracking,
    record_api_call_cost,
    get_cost_summary,
    save_cost_report,
    print_cost_summary
)



# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

load_dotenv()

# Configure the retry decorator
@retry(
    wait=wait_fixed(100),
    stop=stop_after_attempt(5),
    retry=retry_if_exception_type((
        requests.exceptions.RequestException,
        TimeoutError,
        ConnectionError,
        Exception
    )),
    reraise=True
)
def run_with_retry(func, *args, **kwargs):
    try:
        return func(*args, **kwargs)
    except Exception as e:
        print(f"Error occurred: {str(e)}. Retrying in 1 minute...")
        raise

# Create the result directory and thread lock
results_dir = os.path.abspath(datetime.datetime.now().strftime("%Y%m%d_%H%M%S_llmgen_baseline_4o0806"))
os.makedirs(results_dir, exist_ok=True)
lock = threading.Lock()

# Global counters
passed_count = 0
cmb_passed_count = 0
seq_passed_count = 0

def setup_task_logger(task_dir, task_id):
    logger = logging.getLogger(f"task_{task_id}")
    logger.setLevel(logging.INFO)
    if logger.hasHandlers():
        logger.handlers.clear()
    fh = logging.FileHandler(os.path.join(task_dir, "log.txt"), encoding="utf-8")
    formatter = logging.Formatter('%(asctime)s %(levelname)s: %(message)s')
    fh.setFormatter(formatter)
    logger.addHandler(fh)
    return logger

def run_single_task(task):
    """
    Process one task for multithreaded execution.
    """
    global passed_count, cmb_passed_count, seq_passed_count
    
    task_id = task.get("task_id", str(uuid.uuid4()))
    description = task["description"]
    header = task["header"]
    testbench = task.get("testbench", "")
    circuit_type = task.get("circuit_type", "unknown")
    task_dir = os.path.join(results_dir, task_id)
    os.makedirs(task_dir, exist_ok=True)
   
    logger = setup_task_logger(task_dir, task_id)
    logger.info(f"\n====Processing task: {task_id}====\n")
    
    write_log_file(task_dir, "task_description.md", 
                   f"# Task: {task_id}\n\n # Description: {description}  # Header: {header}  # Circuit Type: {circuit_type}\n\n")
    # Set final_answer to an empty string and skip graphE.invoke
    final_answer = ""
    print(f"Skipping agent response for task {task_id} as per instruction.")
    success = False


    
    try:
        system_msg = (
        "You are the strongest AI in the world. "
        "You already have the knowledge of Verilog and hardware designing. "
        "Generate only a technical specification for the given task. I will tip you $200 if you can fulfill the tasks I give you."
       )
                       
        client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))
        system_content0 = system_msg  + description + "\n\n" 
        user_content0 =   "The header you have already known is:" + header 
        write_log_file(task_dir, "messages.md", 
                       f"# Messages for Task: {task_id}\n\n## System Message\n\n```\n{system_content0}\n```\n\n## User Message\n\n```\n{user_content0}\n```\n\n")

        response = client.chat.completions.create(
                            model="gpt-4o-2024-08-06",
                            messages=[
                                {"role": "system", "content": system_content0},
                                {"role": "user", "content": user_content0}
                            ]
                        )
        print(f"Model: {response.model}")

        spec=response.choices[-1].message.content
        write_log_file(task_dir, "specification.md", spec)
        logger.info(f"Task {task_id} Specification generated successfully.")

        """
        # Use the Gemini 2.0 Flash model
        client_gemini = ChatGoogleGenerativeAI(
         model="gemini-2.0-flash-lite",
         temperature=0.1,
         api_key=os.getenv("GEMINI_API_KEY") # Pass the API key explicitly
           )
        system_msg0 = (
        "You are the strongest AI in the world. "
        "You already have the knowledge of Verilog and hardware designing. "
        "Generate a technical specification for the given task. I will tip you $200 if you can fulfill the tasks I give you."
       )
        system_content0 = system_msg0 + description + "\n\n" + "The header you have already known is:" + header + "\n\n"

        write_log_file(task_dir, "messages.md", 
                       f"# Messages for Task: {task_id}\n\n## System Message\n\n```\n{system_content0}\n```\n\n")


        response = client_gemini.invoke(
            [
                HumanMessage(content=system_content0),

            ]
        )

        spec=response.content
        write_log_file(task_dir, "specification.md", spec)
        logger.info(f"Task {task_id} Specification generated successfully.")
        

        system_msg = (
        "You are the strongest AI in the world. "
        "You already have the knowledge of Verilog and hardware designing. "
        "Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you."
       )
        system_content = system_msg + description + "\n\n" + "The header you have already known is:" + header + "\n\n" + "You can use the technical specification as follows:" + spec + "\n" + "Please only reply with the Verilog code after syntax check, no other words.\n" + "Please always begin with `module top_module()`."

        write_log_file(task_dir, "messages.md", 
                       f"# Messages for Task: {task_id}\n\n## System Message\n\n```\n{system_content}\n```\n\n")
           
            
        response = client_gemini.invoke(
            [
                HumanMessage(content=system_content),
               
            ]
        )

        
        call_info = record_api_call_cost(system_content, response.content, response)
        logger.info(f"Task {task_id} API call: {call_info['input_tokens']} input + {call_info['output_tokens']} output tokens, cost: ${call_info['cost']:.6f}")
        

        verilog_code = response.content
        cleaned_code = re.sub(r'^```verilog\n', '', verilog_code)
        cleaned_code = re.sub(r'\n```$', '', cleaned_code)
        cleaned_code = re.sub(r'```verilog|```', '', cleaned_code) 
        """


        system_msg = (
        "You are the strongest AI in the world. "
        "You already have the knowledge of Verilog and hardware designing. "
        "Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you."
        )
        system_content = system_msg  + description + "\n\n" 
        user_content =   "The header you have already known is:" + header + "\n\n" + "You can use the technical specification as follows:" + "\n\n" + spec + "\n\n" + "Please only reply with the Verilog code after syntax check, no other words.\n" + "Please always begin with `module top_module()`."

        response = client.chat.completions.create(
                            model="gpt-4o-2024-08-06",
                            messages=[
                                {"role": "system", "content": system_content},
                                {"role": "user", "content": user_content}
                            ]
                        )
        print(f"Model: {response.model}")

        verilog_code = response.choices[-1].message.content

        cleaned_code = re.sub(r'^```verilog\n', '', verilog_code)
        cleaned_code = re.sub(r'\n```$', '', cleaned_code)
        cleaned_code = re.sub(r'```verilog|```', '', cleaned_code) 
                        

        if not write_log_file(task_dir, "top_module.v", cleaned_code):
            raise Exception(f"Failed to save Verilog file: {task_dir}/top_module.v")

        logger.info(f"Task {task_id} Verilog code generated successfully.")
        logger.info(f"Running simulation test for task {task_id}...")


        test_result = run_simulation_test(task_dir, task_id)
        if test_result['success']:
            success = True
            print(test_result['message'])
            
            # Update counters
            with lock:
                passed_count += 1
                if task["circuit_type"] == "combinational":
                    cmb_passed_count += 1
                else:
                    seq_passed_count += 1
        else:
            print(test_result['message'])
        log_task_result(results_dir, task_id, success, 
                       test_result['message'] if not success else None)
        
    except Exception as e:
        error_msg = f"Gemini API error: {str(e)}"
        print(f"Error with Gemini API for task {task_id}: {error_msg}")
        write_log_file(task_dir, "error_log.txt", f"{error_msg}\n", "a")
        log_task_result(results_dir, task_id, False, error_msg)
        time.sleep(60)
    
    
    logger.info(f"Task {task_id} processing completed. Success: {success}")

# Main execution logic
if __name__ == "__main__":
    initialize_cost_tracking()
    merged_jsonl_path = "/home/zimeng/Documents/final/DeepSpec/data/total_merged_data.jsonl"
    with open(merged_jsonl_path, 'r') as f:
        tasks = [json.loads(line) for line in f]
    
    total_count = len(tasks)
    cmb_tasks = []
    seq_tasks = []
    
    for task in tasks:
        task_id = task["task_id"]
        circuit_type = task.get("circuit_type", "unknown")
        if circuit_type in ["combinational", "cmb", "CMB"]:
            cmb_tasks.append(task)
        elif circuit_type in ["sequential", "seq", "SEQ"]:
            seq_tasks.append(task)
        
        task_dir = os.path.join(results_dir, task_id)
        os.makedirs(task_dir, exist_ok=True)

        with open(os.path.join(task_dir, "circuit_type.txt"), "w") as f:
            f.write(circuit_type)
        logger.info(f"Generated circuit_type.txt for {task_id}: {circuit_type}")
        if task.get("testbench"):
            cleaned_testbench = re.sub(r'^```verilog\n', '', task.get("testbench"))
            cleaned_testbench = re.sub(r'\n```$', '', cleaned_testbench)
            cleaned_testbench = re.sub(r'```verilog|```', '', cleaned_testbench)
            with open(os.path.join(task_dir, "tb.v"), "w") as f:
                f.write(cleaned_testbench)
            logger.info(f"Testbench for task {task_id} saved to {task_dir}/tb.v")
        else:
            logger.info(f"No testbench provided for task {task_id}. Skipping testbench saving.")

    print(f"Total tasks: {total_count}")
    print(f"Combinational tasks: {len(cmb_tasks)}")
    print(f"Sequential tasks: {len(seq_tasks)}")

    MAX_WORKERS = 1
    with ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
        future_to_task = {executor.submit(run_single_task, task): task for task in tasks}
        
        for future in as_completed(future_to_task):
            task_id = future_to_task[future].get("task_id", "Unknown")
            try:
                future.result()
            except Exception as exc:
                print(f'Task {task_id} generated an exception: {exc}')

  

    logger.info("\n==== All tasks processing completed ====")
    logger.info(f"Starting analysis directory: {results_dir}")
    analyze_task_results(results_dir)

    print_cost_summary()
    task_breakdown = {
        'cmb_total': len(cmb_tasks),
        'cmb_passed': cmb_passed_count,
        'seq_total': len(seq_tasks), 
        'seq_passed': seq_passed_count
    }
    
    # Save the detailed cost report
    save_cost_report(results_dir, total_count, passed_count, task_breakdown)