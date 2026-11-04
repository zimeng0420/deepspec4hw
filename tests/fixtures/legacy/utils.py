from typing import Any, Dict, List, Optional
from langchain_core.messages import AnyMessage, AIMessage, HumanMessage
import re, datetime
import os
import subprocess
import json
import threading



_cost_tracking = {
    'total_input_tokens': 0,
    'total_output_tokens': 0,
    'total_cost': 0.0,
    'api_call_count': 0,
    'start_time': None,
    'lock': threading.Lock()
}

def initialize_cost_tracking():
    """Initialize cost tracking"""
    import time
    with _cost_tracking['lock']:
        _cost_tracking['total_input_tokens'] = 0
        _cost_tracking['total_output_tokens'] = 0
        _cost_tracking['total_cost'] = 0.0
        _cost_tracking['api_call_count'] = 0
        _cost_tracking['start_time'] = time.time()

def calculate_gemini_cost(input_tokens, output_tokens):
    """
    Calculate Gemini API call costs
    Based on Gemini 2.0 Flash pricing
    
    Args:
        input_tokens: Number of input tokens
        output_tokens: Number of output tokens
        
    Returns:
        float: Calculated cost
    """
    # Gemini 2.0 Flash pricing (adjust to actual API prices)
    input_cost_per_1k = 0.000075   # Cost per 1,000 input tokens ($0.075/1M tokens)
    output_cost_per_1k = 0.0003    # Cost per 1,000 output tokens ($0.30/1M tokens)
    
    input_cost = (input_tokens / 1000) * input_cost_per_1k
    output_cost = (output_tokens / 1000) * output_cost_per_1k
    
    return input_cost + output_cost

def estimate_token_count(text):
    """
    Estimate the number of tokens in text (rough approximation)
    
    Args:
        text: Input text
        
    Returns:
        int: Estimated token count
    """
    if not text:
        return 0
    # Rough estimate: about four English characters per token; code may be denser
    return int(len(text) / 3.5)

def record_api_call_cost(prompt_text, response_content, response_metadata=None):
    """
    Record the cost of an API call
    
    Args:
        prompt_text: Prompt text
        response_content: Response content
        response_metadata: Response metadata, if available
        
    Returns:
        dict: Cost information for this call
    """
    # Try to obtain exact token counts from response metadata
    input_tokens = 0
    output_tokens = 0
    
    if response_metadata and hasattr(response_metadata, 'usage_metadata'):
        usage = response_metadata.usage_metadata
        input_tokens = getattr(usage, 'input_tokens', 0)
        output_tokens = getattr(usage, 'output_tokens', 0)
    elif response_metadata and hasattr(response_metadata, 'response_metadata'):
        token_usage = response_metadata.response_metadata.get('token_usage', {})
        input_tokens = token_usage.get('input_tokens', 0)
        output_tokens = token_usage.get('output_tokens', 0)
    
    # Estimate token counts when metadata is unavailable
    if input_tokens == 0:
        input_tokens = estimate_token_count(prompt_text)
    if output_tokens == 0:
        output_tokens = estimate_token_count(response_content)
    
    # Calculate cost
    call_cost = calculate_gemini_cost(input_tokens, output_tokens)
    
    # Update global statistics
    with _cost_tracking['lock']:
        _cost_tracking['total_input_tokens'] += input_tokens
        _cost_tracking['total_output_tokens'] += output_tokens
        _cost_tracking['total_cost'] += call_cost
        _cost_tracking['api_call_count'] += 1
    
    return {
        'input_tokens': input_tokens,
        'output_tokens': output_tokens,
        'total_tokens': input_tokens + output_tokens,
        'cost': call_cost
    }

def get_cost_summary():
    """
    Get the current cost summary
    
    Returns:
        dict: Total cost information
    """
    import time
    with _cost_tracking['lock']:
        current_time = time.time()
        runtime = current_time - _cost_tracking['start_time'] if _cost_tracking['start_time'] else 0
        
        return {
            'total_input_tokens': _cost_tracking['total_input_tokens'],
            'total_output_tokens': _cost_tracking['total_output_tokens'],
            'total_tokens': _cost_tracking['total_input_tokens'] + _cost_tracking['total_output_tokens'],
            'total_cost': _cost_tracking['total_cost'],
            'api_call_count': _cost_tracking['api_call_count'],
            'runtime_seconds': runtime,
            'runtime_minutes': runtime / 60,
            'average_cost_per_call': _cost_tracking['total_cost'] / max(1, _cost_tracking['api_call_count']),
            'average_tokens_per_call': (_cost_tracking['total_input_tokens'] + _cost_tracking['total_output_tokens']) / max(1, _cost_tracking['api_call_count'])
        }

def save_cost_report(results_dir, total_tasks=0, passed_tasks=0, task_breakdown=None):
    """
    Save the cost report to a file
    
    Args:
        results_dir: Result directory
        total_tasks: Total number of tasks
        passed_tasks: Number of successful tasks
        task_breakdown: Task classification information
    """
    import datetime
    
    cost_summary = get_cost_summary()
    
    # Create a detailed cost report
    report_lines = [
        "GEMINI BASELINE COST SUMMARY",
        "=" * 50,
        "",
        f"Execution Date: {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}",
        f"Total Runtime: {cost_summary['runtime_seconds']:.2f} seconds ({cost_summary['runtime_minutes']:.2f} minutes)",
        "",
        "TASK SUMMARY:",
        f"Total Tasks: {total_tasks}",
        f"Successful Tasks: {passed_tasks}",
        f"Success Rate: {passed_tasks/max(1, total_tasks):.2%}",
        ""
    ]
    
    
    
    if passed_tasks > 0:
        report_lines.append(f"Cost per Successful Task: ${cost_summary['total_cost']/passed_tasks:.6f}")
    
    # Save to file
    report_content = '\n'.join(report_lines)
    cost_report_path = os.path.join(results_dir, "cost_summary.txt")
    write_file_safe(cost_report_path, report_content)
    
    # Also save detailed data in JSON format
    json_data = {
        **cost_summary,
        'total_tasks': total_tasks,
        'passed_tasks': passed_tasks,
        'success_rate': passed_tasks / max(1, total_tasks),
        'timestamp': datetime.datetime.now().isoformat()
    }
    
   
    json_report_path = os.path.join(results_dir, "cost_summary.json")
    with open(json_report_path, 'w') as f:
        json.dump(json_data, f, indent=2)
    
    print(f"Cost summary saved to: {cost_report_path}")
    print(f"Cost data (JSON) saved to: {json_report_path}")
    
    return cost_summary

def print_cost_summary():
    """Print the current cost summary to the console"""
    cost_summary = get_cost_summary()
    
    print(f"\n{'='*60}")
    print("COST SUMMARY")
    print(f"{'='*60}")
    print(f"Total runtime: {cost_summary['runtime_seconds']:.2f} seconds ({cost_summary['runtime_minutes']:.2f} minutes)")
    print(f"Total API calls: {cost_summary['api_call_count']}")
    print(f"Total input tokens: {cost_summary['total_input_tokens']:,}")
    print(f"Total output tokens: {cost_summary['total_output_tokens']:,}")
    print(f"Total tokens: {cost_summary['total_tokens']:,}")
    print(f"Total estimated cost: ${cost_summary['total_cost']:.6f}")
    print(f"Average cost per call: ${cost_summary['average_cost_per_call']:.6f}")
    print(f"Average tokens per call: {cost_summary['average_tokens_per_call']:.0f}")

def get_research_topic(messages: List[AnyMessage]) -> str:
    """
    Get the research topic from the messages.
    """
    # check if request has a history and combine the messages into a single string
    if len(messages) == 1:
        research_topic = messages[-1].content
    else:
        research_topic = ""
        for message in messages:
            if isinstance(message, HumanMessage):
                research_topic += f"User: {message.content}\n"
            elif isinstance(message, AIMessage):
                research_topic += f"Assistant: {message.content}\n"
    return research_topic


def resolve_urls(urls_to_resolve: List[Any], id: int, disable_github_search = False) -> Dict[str, str]:
    """
    Create a map of the vertex ai search urls (very long) to a short url with a unique id for each url.
    Ensures each original URL gets a consistent shortened form while maintaining uniqueness.
    """
    prefix = f"https://vertexaisearch.cloud.google.com/id/"
    urls = [site.web.uri for site in urls_to_resolve]

    # Create a dictionary that maps each unique URL to its first occurrence index
    resolved_map = {}
    for idx, url in enumerate(urls):
        if disable_github_search and "github.com" in url:
            continue
        if url not in resolved_map:
            resolved_map[url] = f"{prefix}{id}-{idx}"

    return resolved_map


def insert_citation_markers(text, citations_list):
    """
    Inserts citation markers into a text string based on start and end indices.

    Args:
        text (str): The original text string.
        citations_list (list): A list of dictionaries, where each dictionary
                               contains 'start_index', 'end_index', and
                               'segment_string' (the marker to insert).
                               Indices are assumed to be for the original text.

    Returns:
        str: The text with citation markers inserted.
    """
    # Sort citations by end_index in descending order.
    # If end_index is the same, secondary sort by start_index descending.
    # This ensures that insertions at the end of the string don't affect
    # the indices of earlier parts of the string that still need to be processed.
    sorted_citations = sorted(
        citations_list, key=lambda c: (c["end_index"], c["start_index"]), reverse=True
    )

    modified_text = text
    for citation_info in sorted_citations:
        # These indices refer to positions in the *original* text,
        # but since we iterate from the end, they remain valid for insertion
        # relative to the parts of the string already processed.
        end_idx = citation_info["end_index"]
        marker_to_insert = ""
        for segment in citation_info["segments"]:
            marker_to_insert += f" [{segment['label']}]({segment['short_url']})"
        # Insert the citation marker at the original end_idx position
        modified_text = (
            modified_text[:end_idx] + marker_to_insert + modified_text[end_idx:]
        )

    return modified_text


def get_citations(response, resolved_urls_map, disable_github_search):
    """
    Extracts and formats citation information from a Gemini model's response.

    This function processes the grounding metadata provided in the response to
    construct a list of citation objects. Each citation object includes the
    start and end indices of the text segment it refers to, and a string
    containing formatted markdown links to the supporting web chunks.

    Args:
        response: The response object from the Gemini model, expected to have
                  a structure including `candidates[0].grounding_metadata`.
                  It also relies on a `resolved_map` being available in its
                  scope to map chunk URIs to resolved URLs.

    Returns:
        list: A list of dictionaries, where each dictionary represents a citation
              and has the following keys:
              - "start_index" (int): The starting character index of the cited
                                     segment in the original text. Defaults to 0
                                     if not specified.
              - "end_index" (int): The character index immediately after the
                                   end of the cited segment (exclusive).
              - "segments" (list[str]): A list of individual markdown-formatted
                                        links for each grounding chunk.
              - "segment_string" (str): A concatenated string of all markdown-
                                        formatted links for the citation.
              Returns an empty list if no valid candidates or grounding supports
              are found, or if essential data is missing.
    """
    citations = []

    # Ensure response and necessary nested structures are present
    if not response or not response.candidates:
        return citations

    candidate = response.candidates[0]
    if (
        not hasattr(candidate, "grounding_metadata")
        or not candidate.grounding_metadata
        or not hasattr(candidate.grounding_metadata, "grounding_supports")
    ):
        return citations

    for support in candidate.grounding_metadata.grounding_supports:
        citation = {}

        # Ensure segment information is present
        if not hasattr(support, "segment") or support.segment is None:
            continue  # Skip this support if segment info is missing

        start_index = (
            support.segment.start_index
            if support.segment.start_index is not None
            else 0
        )

        # Ensure end_index is present to form a valid segment
        if support.segment.end_index is None:
            continue  # Skip if end_index is missing, as it's crucial

        # Add 1 to end_index to make it an exclusive end for slicing/range purposes
        # (assuming the API provides an inclusive end_index)
        citation["start_index"] = start_index
        citation["end_index"] = support.segment.end_index

        citation["segments"] = []
        if (
            hasattr(support, "grounding_chunk_indices")
            and support.grounding_chunk_indices
        ):
            for ind in support.grounding_chunk_indices:
                try:
                    chunk = candidate.grounding_metadata.grounding_chunks[ind]
                    resolved_url = resolved_urls_map.get(chunk.web.uri, None)

                    if disable_github_search and "github.com" in chunk.web.uri:
                        # Skip GitHub links if the search is disabled
                        continue
                    citation["segments"].append(
                        {
                            "label": chunk.web.title.split(".")[:-1][0],
                            "short_url": resolved_url,
                            "value": chunk.web.uri,
                        }
                    )
                except (IndexError, AttributeError, NameError):
                    # Handle cases where chunk, web, uri, or resolved_map might be problematic
                    # For simplicity, we'll just skip adding this particular segment link
                    # In a production system, you might want to log this.
                    pass
        citations.append(citation)
    return citations



def postprocess_verilog_code(code):
    """
    Postprocess generated Verilog code
    """
    if not code or code.strip() == "":
        return ""
    
    # 1. Remove code-fence markers
    code = re.sub(r'^```verilog\s*', '', code, flags=re.MULTILINE)
    code = re.sub(r'^```\s*$', '', code, flags=re.MULTILINE)
    
    # 2. Remove verilog/Verilog labels and related comments
    code = re.sub(r'//.*?(?:verilog|Verilog).*?\n', '\n', code, flags=re.IGNORECASE)
    code = re.sub(r'/\*.*?(?:verilog|Verilog).*?\*/', '', code, flags=re.IGNORECASE | re.DOTALL)
    code = re.sub(r'(?:verilog|Verilog)\s*code[:\s]*', '', code, flags=re.IGNORECASE)
    
    # 3. Remove redundant blank lines
    code = re.sub(r'\n\s*\n\s*\n', '\n\n', code)
    code = code.strip()
    
    # 4. Ensure a module top_module declaration exists
    has_top_module = re.search(r'^\s*module\s+top_module', code, re.MULTILINE)
    has_endmodule = re.search(r'^\s*endmodule', code, re.MULTILINE)
    
    if not has_top_module:
        # Find the first module declaration and rename it to top_module
        module_match = re.search(r'^\s*module\s+(\w+)', code, re.MULTILINE)
        if module_match:
            original_name = module_match.group(1)
            code = re.sub(
                r'^\s*module\s+' + re.escape(original_name),
                'module top_module',
                code,
                flags=re.MULTILINE
            )
        else:
            # Add a basic module skeleton if no declaration is found
            print("Warning: No module declaration found, adding basic structure")
            code = f"module top_module(\n    // ports to be defined\n);\n\n{code}\n\nendmodule"
    
    # 5. Ensure endmodule exists
    if not has_endmodule:
        if not code.strip().endswith('endmodule'):
            code = code.rstrip() + '\nendmodule'
    
    # 6. Formatting: ensure a newline before endmodule
    code = re.sub(r'([^\n])\s*endmodule', r'\1\nendmodule', code)
    
    # 7. Final cleanup
    lines = code.split('\n')
    cleaned_lines = []
    for line in lines:
        # Remove unnecessary surrounding whitespace while preserving indentation
        if line.strip():
            cleaned_lines.append(line.rstrip())
        else:
            cleaned_lines.append('')
    
    # Remove leading and trailing blank lines
    while cleaned_lines and not cleaned_lines[0].strip():
        cleaned_lines.pop(0)
    while cleaned_lines and not cleaned_lines[-1].strip():
        cleaned_lines.pop()
    
    return '\n'.join(cleaned_lines)


def write_file_safe(filepath: str, content: str, mode: str = "w") -> bool:
    """
    Write a file safely, creating directories automatically
    
    Args:
        filepath: File path
        content: Content to write
        mode: File open mode ('w', 'a', etc.)
        
    Returns:
        bool: True on successful write, False otherwise
    """
    try:
        # Ensure the directory exists
        os.makedirs(os.path.dirname(filepath), exist_ok=True)
        
        with open(filepath, mode, encoding='utf-8') as f:
            f.write(content)
        return True
    except Exception as e:
        print(f"Error writing to {filepath}: {str(e)}")
        return False

def write_result_file(task_dir: str, filename: str, content: str, mode: str = "a") -> bool:
    """
    Convenience function for writing result files
    
    Args:
        results_dir: Result directory
        filename: File name
        content: Content
        mode: File mode
        
    Returns:
        bool: Whether writing succeeded
    """
    task_dir = os.path.abspath(task_dir)
    filepath = os.path.join(task_dir, filename)
    print(f"[DEBUG] Writing {filename} to: {filepath}")
    return write_file_safe(filepath, content, mode)

def write_log_file(task_dir: str, filename: str, content: str, mode: str = "w") -> bool:
    """
    Write a log file
    
    Args:
        task_dir: Task directory
        filename: File name
        content: Content
        mode: File mode
        
    Returns:
        bool: Whether writing succeeded
    """
    task_dir = os.path.abspath(task_dir)
    filepath = os.path.join(task_dir, filename)
    print(f" Writing {filename} to: {filepath}")
    return write_file_safe(filepath, content, mode)

def run_simulation_test(task_dir: str, task_id: str) -> Dict[str, Any]:
    """
    Simulation-test utility function
    
    Args:
        task_dir: Task directory
        task_id: Task ID
        
    Returns:
        Dict: Test results
    """
    result = {
        'success': False,
        'status': 'unknown',
        'message': '',
        'compile_result': None,
        'sim_result': None
    }
    
    orig_dir = os.getcwd()
    task_dir = os.path.normpath(os.path.abspath(task_dir))
    
    try:
        os.chdir(task_dir)
        
        # Check whether the testbench exists
        if not os.path.exists("tb.v"):
            result['status'] = 'skip'
            result['message'] = f"No testbench (tb.v) found for task {task_id}"
            test_result_path = os.path.join(task_dir, "test_result.txt")
            write_file_safe(test_result_path, "SKIP: No testbench available\n")
            return result
        
        # Compile
        compile_cmd = ["iverilog", "-g2012", "-o", "sim.vvp", "top_module.v", "tb.v"]
        compile_result = subprocess.run(
            compile_cmd,
            capture_output=True,
            text=True
        )
        
        # Write the compilation log
        compile_log = compile_result.stdout + compile_result.stderr
        write_log_file(task_dir, "compile_log.txt", compile_log)
        result['compile_result'] = compile_result
        
        if compile_result.returncode != 0:
            result['status'] = 'compile_fail'
            result['message'] = f"Compilation for task {task_id} failed"
            write_log_file(task_dir, "test_result.txt", 
                         f"FAIL: Compilation failed\n\nCompilation Errors:\n{compile_result.stderr}")
            return result
        
        if compile_result.returncode == 0:
            result['compile_success'] = True
            
            print(f"Compilation successful for task {task_id}, running simulation...")
        
          # Run simulation
            sim_cmd = ["vvp", "sim.vvp"]
            sim_result = subprocess.run(
            sim_cmd,
            capture_output=True,
            text=True,
            timeout=30
            )
        
         # Write the simulation log
            sim_log = sim_result.stdout + sim_result.stderr
            write_log_file(task_dir, "simulation_log.txt", sim_log)
            result['sim_result'] = sim_result
        
            if sim_result.returncode == 0:
                mismatch_match = re.search(r"Mismatches:\s*(\d+)", sim_result.stdout)
                mismatches = int(mismatch_match.group(1)) if mismatch_match else -1
        
                if mismatches == 0:
                    result['success'] = True
                    result['status'] = 'pass'
                    result['message'] = f"Task {task_id} completed successfully with 0 mismatches!"
                    test_content = "PASS: Simulation completed without errors\n" + f"\nSimulation Output:\n{sim_result.stdout}"
                else:    
                    result['success'] = False  # Set False to indicate functional-test failure
                    result['status'] = 'compile_pass_sim_fail'
                    if mismatches > 0:
                        result['message'] = f"Task {task_id}: Simulation ran successfully but has {mismatches} mismatches"
                    else:
                        result['message'] = f"Task {task_id}: Simulation ran successfully but mismatch count unknown"
                    test_content = f"FAIL: Functional test failed with {mismatches} mismatches\n\nSimulation Output:\n{sim_result.stdout}"
                
                write_log_file(task_dir, "test_result.txt", test_content)
            else:
                # Historical behavior: count failed simulation after successful compilation as task completion
                result['success'] = True
                result['status'] = 'compile_success_sim_fail'
                result['message'] = f"Task {task_id}: Code generated and compiled successfully, but simulation failed"
            
                test_content = (
                    "PASS: Compilation successful, simulation had issues\n"
                    f"\nSimulation Error Output:\n{sim_result.stderr}"
                )
                
                write_log_file(task_dir, "test_result.txt", test_content)
        
    except subprocess.TimeoutExpired:
        result['success'] = True
        result['status'] = 'pass_timeout'
        result['message'] = f"Task {task_id}: Code generated successfully, but simulation timeout"
        write_log_file(task_dir, "test_result.txt", "PASS: Code compiled, but simulation timeout\n")
        
    except Exception as e:
        result['status'] = 'error'
        result['message'] = f"Error during simulation for task {task_id}: {str(e)}"
        
        error_content = f"ERROR: Test execution failed\n{str(e)}\n"
        write_log_file(task_dir, "test_result.txt", error_content)
        write_log_file(task_dir, "error_log.txt", f"Simulation/Compilation error: {str(e)}\n", "a")
        
    finally:
        os.chdir(orig_dir)
    
    return result

def log_task_result(results_dir: str, task_id: str, success: bool, error_msg: Optional[str] = None):
    """
    Record the task result in the appropriate file
    
    Args:
        results_dir: Result directory
        task_id: Task ID
        success: Whether the task succeeded
        error_msg: Optional error message
    """
    if success:
        write_result_file(results_dir, "success.txt", f"{task_id} \n")
    else:
        error_content = f"{task_id}            ERROR: {error_msg}\n" if error_msg else f"{task_id} FAILED\n"
        write_result_file(results_dir, "failed.txt", error_content)

def analyze_task_results(base_dir):
    """
    analyze the results of tasks in the specified directory.
    
    Args:
        base_dir: The base directory of task results
    """
    # Initialize counters
    total_tasks = 0
    syntax_passed = 0  # Syntax passed
    func_passed = 0    # Functionality passed
    cmb_total = 0
    cmb_syntax_passed = 0
    cmb_func_passed = 0
    seq_total = 0
    seq_syntax_passed = 0
    seq_func_passed = 0
    cmb_passed_tasks = []
    seq_passed_tasks = []
    
    # Get all task directories
    task_dirs = [d for d in os.listdir(base_dir) 
                if os.path.isdir(os.path.join(base_dir, d)) 
                and not d.startswith('.') 
                and d not in ["logs", "comparison_results"]]

    print(f"Found {len(task_dirs)} task directories")
    total_tasks = len(task_dirs)
    

    # Analyze each task directory
    for task_id in task_dirs:
        task_dir = os.path.join(base_dir, task_id)
        is_syntax_passed = False  
        is_func_passed = False   
        circuit_type = "sequential"

        # Read circuit type
        circuit_type_file = os.path.join(task_dir, "circuit_type.txt")
        if os.path.exists(circuit_type_file):
            with open(circuit_type_file, 'r') as f:
                circuit_type = f.read().strip()

            if circuit_type == "combinational" or circuit_type == "cmb" or circuit_type == "CMB":
                cmb_total += 1
            elif circuit_type == "sequential" or circuit_type == "seq" or circuit_type == "SEQ":
                seq_total += 1

        # Check test results
        test_result_file = os.path.join(task_dir, "test_result.txt")
        if os.path.exists(test_result_file):
            with open(test_result_file, 'r') as f:
                content = f.read()
                # Check syntax passed
                if not "FAIL: Compilation failed" in content:
                    is_syntax_passed = True
                    syntax_passed += 1
                    if circuit_type == "combinational" or circuit_type == "cmb" or circuit_type == "CMB":
                        cmb_syntax_passed += 1
                    elif circuit_type == "sequential" or circuit_type == "seq" or circuit_type == "SEQ":
                        seq_syntax_passed += 1

                # Check functionality passed
                if "Mismatches: 0" in content:
                    is_func_passed = True
                    func_passed += 1
                    if circuit_type == "combinational" or circuit_type == "cmb" or circuit_type == "CMB":
                        cmb_func_passed += 1
                        cmb_passed_tasks.append(task_id)
                    elif circuit_type == "sequential" or circuit_type == "seq" or circuit_type == "SEQ":
                        seq_func_passed += 1
                        seq_passed_tasks.append(task_id)


        # Print task status
        status = []
        if is_syntax_passed: status.append("Syntax passed")
        if is_func_passed: status.append("Functionality passed")
        if not status: status.append("Not passed")
        status_str = ", ".join(status)
        print(f"Task {task_id}: Type={circuit_type}, Status={status_str}")

    print("\n===== Results Summary =====")

    save_dir = base_dir
    os.makedirs(save_dir, exist_ok=True)
    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    file_name = f"analysis_results_{timestamp}.txt"

    print(f"functionaly_passed_tasks: cmb: {cmb_passed_tasks}")
    print(f"functionaly_passed_tasks: seq: {seq_passed_tasks}")
    # Prepare the summary text
    txt = ""
    txt += f"Total tasks: {total_tasks}\n"
    txt += f"Syntax passed: {syntax_passed} ({syntax_passed/total_tasks:.2%})\n"
    txt += f"Functionality passed: {func_passed} ({func_passed/total_tasks:.2%})\n"
    
    txt += f"\nCombinational tasks: {cmb_total}\n"
    if cmb_total > 0:
        txt += f"Syntax passed: {cmb_syntax_passed}/{cmb_total} ({cmb_syntax_passed/cmb_total:.2%})\n"
        txt += f"Functionality passed: {cmb_func_passed}/{cmb_total} ({cmb_func_passed/cmb_total:.2%})\n"
    
    txt += f"\nSequential tasks: {seq_total}\n"
    if seq_total > 0:
        txt += f"Syntax passed: {seq_syntax_passed}/{seq_total} ({seq_syntax_passed/seq_total:.2%})\n"
        txt += f"Functionality passed: {seq_func_passed}/{seq_total} ({seq_func_passed/seq_total:.2%})\n"
    
    # Format the summary table
    txt += f"\n{'Total tasks':<25} | {'Combinational tasks':<30} | {'Sequential tasks':<30}\n"
    txt += f"{'-'*25}   | {'-'*30}    | {'-'*30}\n"
    txt += f"{func_passed}/{total_tasks} ({func_passed/total_tasks:.2%}) | {cmb_func_passed}/{cmb_total} ({cmb_func_passed/max(1,cmb_total):.2%}) | {seq_func_passed}/{seq_total} ({seq_func_passed/max(1,seq_total):.2%})\n"
    
    # write to file
    with open(os.path.join(save_dir, file_name), 'w') as f:
        f.write(txt)
