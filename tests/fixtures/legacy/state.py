from __future__ import annotations

from dataclasses import dataclass, field
from typing import TypedDict, List

from langgraph.graph import add_messages
from typing_extensions import Annotated
from typing import TypedDict, List, Optional, Any, Dict 

import operator
from dataclasses import dataclass, field
from typing_extensions import Annotated
from .tools_and_schemas import (
    SearchQueryList,
    TopicAnalyze,
    StrategyAnalyze,
    AnalyzeReport,
    Reflection,
   

    )

class OverallState(TypedDict):
    messages: Annotated[list, add_messages]
    search_query: Annotated[list, operator.add]
    web_research_result: Annotated[list, operator.add]
    sources_gathered: Annotated[list, operator.add]
    modules: Annotated[list, operator.add]
    initial_search_query_count: int
    max_research_loops: int
    research_loop_count: int
    research_topic: str
    
    explanation: dict
    reasoning_model: str
    adaptation: Annotated[list, operator.add]
    jsonl_results: dict
    aggregated_results: dict
    analyze_report: dict
    
    CMB_logic_summary: str
    Timing_logic_summary: str
    final_answer: str
    finalized_answer: str

    retry_count: int
    retry_reflection_count: int
    combined_feedback: str
    reflection_A_passed: bool
    reflection_B_passed: bool
    reflection_feedback: str
    reflection_A_feedback: str
    reflectionB_feedback: str
    compressed_answer: str
    corrected_answer: str
    content_to_reflect: str

    header: str
    description: str
    task_number: int
    task_dir: str
    task_id: str
    circuit_type: str
    spec: str
    code: str
    testbench: str

    syntax_passed_state: bool
    funct_passed_state: bool
    cmb_count: int
    seq_count: int
    total_count: int


    mindtraced_research_topic: str

    compression_passed: bool
    compression_versions: Annotated[list, operator.add]
    selected_version: str
    selection_metrics: dict
    version_id: int
    temperature: float
    info_retention: float
    info_density: float
    task_relevance: float
    compression_ratio: float
    compression_score: float
    composite_score: float
    content_length: int
    original_description: str
    original_length: int
    reflection_failed_badly: bool
    best_score: float
    jaccard_similarity_value: float
   

    content_to_reflect: str  # Used by the correction function
    


    correction_status: str   # "completed", "max_retries_reached", "failed"
    final_answer: str        # Final answer, required in every case
    messages_history: Annotated[list, add_messages]  # Message history, including all user and AI messages
  
   
    best_version_metrics: Dict[str, Any]

    atomic_sets_X: Optional[List[str]]  
    atomic_sets_Y: Optional[List[str]]  
    decomposition_method: Optional[str] 
    
    # Reflection B outputs
    conflict_analysis: Optional[Dict[str, Any]]  
    conflicts: Optional[List[Dict[str, Any]]]  
    intersection: Optional[List[str]]  
    union: Optional[List[str]]  
   
    
    # Flow-control fields
    is_consistent: Optional[bool]  
    
    is_consistent_B: Optional[bool]  
    reflection_feedback: Optional[str]  
    reflectionB_feedback: Optional[str]  
    

    best_version_info: Dict[str, Any]  # Complete information about the best version
    version_selection_log: Dict[str, Any]  # Version-selection log
    
    # **Workflow state management** (tracks version selection)
    version_selection_completed: bool  # Whether version selection has completed
   
    best_version_selected: bool        # Whether the best version has been selected
    
    # **Missing fields used by the compression function**
    compression_results: Dict[str, Any]  # Storage for compression results
    
    # **Fields used by select_best_version** 
    openai_api_available: bool         # Whether the OpenAI API is available
    embedding_calculation_success: bool # Whether embedding calculation succeeded
    version_selection_error: Optional[str]  # Error during version selection

   

class ReflectionState(TypedDict):
    is_sufficient: bool
    knowledge_gap: str
    follow_up_queries: Annotated[list, operator.add]
    research_loop_count: int
    number_of_ran_queries: int
    messages: list
    search_query: Annotated[list, operator.add]
    sources_gathered: Annotated[list, operator.add]
    notes: str
    retry_count: int

class Query(TypedDict):
    query: str
    rationale: str


class QueryGenerationState(TypedDict):
    query_list: list[Query]
    task_id: str
    task_dir: str
    messages: Annotated[list, add_messages]

class WebSearchState(TypedDict):
    search_query: str
    id: str
    task_id: str
    task_dir: str
    messages: Annotated[list, add_messages]
  



    
@dataclass(kw_only=True)
class SearchStateOutput:
    running_summary: str = field(default=None)  # Final report
    aggregated_results: str = field(default=None)
    research_topic: str = field(default=None)
    top_module_header: str = field(default=None)