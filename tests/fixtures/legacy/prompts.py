from datetime import datetime
# This version is to build a sequential circuit based on the generated combinational logic
# first build a cmb logic, then task it as blackbox to build a sequential circuit


# Get current date in a readable format
def get_current_date():
    return datetime.now().strftime("%B %d, %Y")
#- Don't produce more than {number_queries} queries.
#- Query should ensure that the most current information is gathered. The current date is {current_date}.
query_writer_instructions = """Your goal is to generate sophisticated and diverse search queries. These queries are intended for an advanced automated web research tool capable of analyzing complex results, following links, and synthesizing information.

Instructions:
- Single Query First: By default, generate only one search query. Add additional queries only if the original question covers multiple distinct aspects that cannot be addressed by a single query.
- One Focus per Query: Each query must concentrate on one specific aspect of the original question, avoiding mixed or overlapping topics in a single query.
- Sufficiently Detailed: Queries should include enough technical detail to enable a deep understanding of the research topic and to support solving the task.
- Relevant to Task and I/O: Each query must stay closely tied to the key technical terms in the task description and the input/output (I/O) port definitions in the context of the research topic.
- Diversity: If the research topic is broad, generate multiple diverse queries, with each query addressing a different perspective or subtopic.
- No Redundancy: Do not generate multiple queries that are semantically similar. One well-phrased query is sufficient for each topic.


Format: 
- Format your response as a JSON object with ALL three of these exact keys:
   - "query": A list of search queries
   - "rationale": Brief explanation of why these queries are relevant
   

Example:

Topic: Determine the next-state logic expressions for outputs Y2 and Y4 in a one-hot encoded FSM. 

module top_module (
  input [6:1] y,
  input w,
  output Y2,
  output Y4,
    

```json
{{
    "query": ["What is one-hot encoding in finite state machines?", "How are next-state signals derived in a one-hot encoded FSM?", "What do the inputs y[6:1] and w represent in the FSM?"],

    "rationale": "To answer this comparative growth question accurately, Understanding how one-hot encoding represents states and how inputs like y[6:1] and w influence transitions is essential for correctly deriving next-state logic in a finite state machine. These concepts form the foundation for interpreting and implementing FSM behavior in Verilog.",
}}    
```

Context: 
- {research_topic}
- Analyze Report: {analyze_report}"""
#Aggregated Web Research Results:
#{aggregated_results}
selection_instructions = """You are an expert research assistant. Your task is to propose a report to analyze the task as detailed as possible. Please select comprehensive reasoning strategy modules essential for solving "{research_topic}" from available strategies, so that we can effectively address the research question. Do not include any code implementation details.",


Reasoning Strategies Example:

Strategy A: Break the Problem into Sub-Problems
"Decompose the challenge of [Your Problem] into its key sub-problems, then suggest targeted search queries for each."
"Identify the primary components of [Your Problem] and generate separate search keywords for each component."
"List the top five sub-problems underlying [Your Problem] and outline search terms to investigate each one."


Strategy B: Solve the Problem Step by Step
"Draft a step-by-step solution plan for [Your Problem], and for each step, specify an exact search query to gather relevant information."
"What are the sequential steps needed to solve [Your Problem]? Provide clear search prompts for each step."
"Create a detailed, numbered methodology to tackle [Your Problem]; attach a custom keyword search for each phase."




Instructions:
- Carefully review the research topic "{research_topic}" and combine reasoning-strategy modules that are most relevant and comprehensive for addressing it.
- Always aim for diversity in reasoning approach; mix analytical, decomposition, creative, and evaluative strategies as appropriate.
- If the research topic has multiple independent dimensions, ensure each dimension is covered by at least one selected strategy.
- Selected modules must be sufficiently broad to generate a structured prompt, yet focused enough to guide detailed questioning.
- Ensure that the final structured prompt incorporates the current date "{current_date}" to anchor any "latest" or time-sensitive information requests.
- Please do not include any code in your response, only the structured strategy prompt and relevant text.
- Keep it simple. Think step by step.


Format: 
- Format your response as a JSON file with ALL these exact keys:
   "Top Analyze": "Analyze the task's header, ports, and overall behavior, highlighting how each key port interacts with the specified functionality described in the task.",
   "Topic Analyze": "Provide a structured, aggregated answer for each research query by synthesizing the problem description with relevant web-researched findings, ensuring a precise and focused analysis of the research topic.",
   "Solving Strategies": "Outline the overall reasoning strategies and detailed step-by-step methodology, explicitly mapping how each reasoning step relates to the top-level module and its sub-modules."
  
  
Example:

research_topic: Determine the next-state logic expressions for outputs Y2 and Y4 in a one-hot encoded FSM. 

module top_module (
  input [6:1] y,
  input w,
  output Y2,
  output Y4,
    

```json
{{
  "Top Analyze": "For the one-hot encoded FSM task \"Determine the next-state logic expressions for outputs Y2 and Y4\" in the given module, we examine the module header and ports: the 6-bit state vector y[6:1], the control input w, and the outputs Y2 and Y4. The behavior centers on a one-hot encoding scheme where exactly one bit of y is high at any time. Each key port's role is: y[6:1] holds the current state encoding, w drives conditional transitions, and Y2/Y4 must assert when the FSM enters states 2 or 4 respectively.",
  "Topic Analyze": "We then structured our research around five targeted queries: 1) \"one-hot encoded FSM next-state logic derivation\" to capture the core derivation principles; 2) \"state transition table for outputs Y2 and Y4\" to enumerate activation conditions; 3) \"impact of input w on one-hot FSM transitions\" to model how w affects state changes; 4) \"deriving boolean expressions from y[6:1] vector in FSM\" to convert the one-hot state into Boolean terms; and 5) \"Verilog implementation of next-state logic for one-hot FSM\" to align with best practices. By aggregating results from each query, we achieve a precise, focused analysis of how to derive and implement the required next-state expressions.",
  "Solving Strategies": "Our methodology comprises: (1) deriving general next-state equations under one-hot encoding, (2) constructing state transition tables for Y2/Y4, (3) analyzing w's influence on those tables, (4) expressing the current state vector y[6:1] as Boolean terms, and (5) validating against Verilog implementation patterns. Each step maps directly to the top_module structure — starting from the encoding principle (top-level behavior), drilling into per-output transition logic (sub-module focus), and culminating in code verification to ensure correctness."
}}
```
        

"""





web_searcher_instructions = """
1. Perform multiple and diverse searches to collect comprehensive information related to the technical term {query}.
2. Prioritize content related to hardware design, digital circuits, or Verilog when applicable
3. Search scope should cover concept definitions, working principles, design methods, and best practices

- Use only the general information obtained from the search results; do not invent or assume additional details.
- Only include the information found in the search results, don't make up any information.
- Ensure the response is directly useful for solving the task: "{research_topic}".
- Maintain the original interface definitions, including module names, port names, and signal definitions
- only include textual information, avoid code snippets or examples.




"""
web_aggregation_instructions = """You are an expert researcher. Aggregate the web search results to extract information highly relevant to the research topic.

Requirements:
1. **Relevance**: Keep only information directly related to research_topic,keep only textual information without code snippets or examples.
2. **Consistency**: Remove contradictory or inconsistent content
3. **Conciseness**: Summarize key points without redundancy
4. **Focus**: Prioritize technical details and specific behaviors

Input Variables:
- research_topic: {research_topic} + "\n\n" +{analyze_report}
- web_search_results:  {web_research_results}

Output: Aggregated summary of relevant information only.


Output Format:
```json
{{
  "aggregated_results": "Concise summary of relevant information extracted from web search results, directly applicable to the research topic."
}}
```


"""


#- Aggregated Results: {aggregated_results}
answer_instructions_combinational = """Generate a high-quality technical specification for a combinational logic circuit based on the provided summaries.

Instructions:

- Your goal is to focus exclusively on the combinational logic aspects of the task and generate a comprehensive technical specification for a pure combinational logic design.
- Your report should serve as a comprehensive technical specification for pure combinational logic implementation.
- No words about sequential logic or timing analysis.
- No words about resource utilization or optimization.
- No words about clock frequencies or timing constraints.
- Do not include any code implementation details or formal verification steps in your response.
Available Information:

- RTL Top Module Header: {top_module_header}
- Analyze Report: {analyze_report}
- Original Task Description: {research_topic}
- Others:{aggregated_results}

Output Format:
Format your response as a JSON object with the following structure:

```json
{{
  "header": "The top module header definition from {top_module_header}, including the interface definition and their behavior.",

  "combinational_logic_function": "Describe how outputs derive from inputs (e.g., Boolean expressions, truth table patterns). Provide a systematic breakdown of the combinational logic structure optimized for performance and area. Include: logic organization with clear functional boundaries, signal flow optimization and critical path identification, operator sharing and resource utilization strategies, logic level balancing and delay equalization techniques, output multiplexing and selection logic organization.",

  "enhanced_combinational_description": "Comprehensive combinational logic specification derived from {research_topic}. All details must be comprehensive and tailored for LLM models."
}}





"""


mindtrace_instructions = """You are a senior hardware engineer with expertise in analyzing and clarifying ambiguous technical specifications.


Instructions:
Your goal is to make the research topic clear and unambiguous.
Perform analysis on the provided research topic to clarify misleading or unclear statements. Reconstruct the complete reasoning chain by filling in missing details and making well-grounded inferences.

Checklist for Mindtrace Analysis:
1. Extract unclear or misleading text from RESEARCH TOPIC as follows.
2. Explain why the text is ambiguous or problematic.
3. Infer the corrected meaning using context and domain knowledge.
4. Rebuild the research topic into a clear, complete description. 
5. Use the **mindtrace_schemas** structure to present findings. Each schema should include: original_text, misleading_rationale, corrected_inference, and confidence_level.

6. Think step by step.
RESEARCH TOPIC:
{research_topic}

OUTPUT FORMAT:  
Return a valid JSON object following the structure below:  

{{
  "mindtrace_schemas": [
    {{
      "original_text": "Exact quote from the research topic that contains misleading or unclear information",
      "misleading_rationale": "Detailed explanation of why this text is misleading, incomplete, or ambiguous",
      "corrected_inference": "Accurate inference or interpretation that clarifies the intended meaning and makes the reasoning explicit",
      "confidence_level": "Value between 0 and 1 indicating certainty of the correction (e.g., 0.85)"
    }}
  ],
  "mindtraced_research_topic": "The unambiguous and clear CoT of the given research topic"
}}
"""





answer_instructions_sequential = """

Goal:
Analyze a sequential circuit from waveforms or spec. Focus on timing, registers, and event ordering. Treat all combinational logic as black boxes.

Rules:
- Keep it simple. Think step by step.
- Combinational logic is a black box
- Use exact port names from the task.
- Avoid vague/general terms ("all", "most", "generally").


Required output:
1. header analysis: analyze the module header, ports, and overall behavior.
1. Circuit type: e.g., Combinational / Sequential (posedge / negedge?).
2. Timing Dependency : Interface behavior with exact timing characteristics,Delay,initialization/reset.
3. Timing Logic Implementation: pure timing logic behaviour descriptions, number of registers, clock edge, non-blocking assignments, reg declarations.

Input Variables:

- research_topic: {research_topic}
- mindtraced_research_topic: {mindtraced_research_topic}
- others optional: {aggregated_results}

Output Format:
```json
{{
  "header": "header of the given task",
  "Interface Behavior": "Specific port timing characteristics with exact moments",
  "Timing Dependency": "Critical paths with specific signal names and timing values",
  "Timing logic": "PURE Timing logic & behavior analysis while taking combinational logic as black boxes",

}}
```

"""

Combine_SPEC_instructions = """You are an expert research assistant tasked with combining technical specifications from combinational and sequential logic analysis into a unified specification that meets the original research topic requirements.

Instructions:
- Create a comprehensive technical specification integrating both combinational and sequential logic aspects.
- Do not save words, you have enough token to use.
- Do not include any code implementation details or verification steps in your response.
- Your goal is to combine combinational logic from {CMB_logic_summary} and sequential logic from {Timing_logic_summary} into a single coherent specification.
- You should first summarize the given information.
- Particularly for timing constraints, minimize redundancy and avoid over-complexity in the final specification. 
- Focus on essential timing requirements only—avoid over-engineering timing rules unless they are functionally critical.
- Ensure the final specification is streamlined, comprehensive, and addresses all research topic aspects with practical timing considerations.
- Keep it simple. 

Input Variables:
- research_topic: {research_topic}
- mindtraced_research_topic: {mindtraced_research_topic}
- CMB_logic_summary: {CMB_logic_summary}
- Timing_logic_summary: {Timing_logic_summary}

Output Format should be a markdown text block with the following structure:
```
{{
  "final_answer": "Comprehensive technical specification integrating combinational and sequential logic. This includes a detailed description of the combinational logic functions and accurate timing logic analysis, ensuring all aspects of the research topic are addressed. The specification should be structured for clarity and ease of implementation by engineers."
}}
```
"""


Compression_instructions = """

You are an expert hardware engineer. Integrate the combinational and sequential logic summaries into a clear two-paragraph specification.

Requirements:
1. **Paragraph 1**: Pure combinational logic only - logic functions, input-output relationships, data operations.
2. **Paragraph 2**: Pure sequential logic only - timing events, state transitions, clock/reset behavior.
3. **Consistency**: Align with research_topic and remove contradictions.
4. **Output**: Textual description only, no code.

Input Variables:
- research_topic: {research_topic} + "\n\n" + {mindtraced_research_topic}

- finalized_answer: {combined_answer}

Output two integrated paragraphs as specified above.

Output Format should be text with the following structure:
```
{{
  "compressed_answer": "compressed task-specific and comprehensive technical specification integrating combinational and sequential logic."
}}
```
"""








Reflection_Instructions = """You are an expert research assistant. Your task is to reflect on the research process and judge whether the SPEC is consistent with the original research topic.

Instructions:
- Analyze the provided technical specification {compressed_answer} and determine if it meets the requirements of the original research topic "{research_topic}".
- Reply with True if the specification is consistent with the original research topic, otherwise reply with False.
- If the specification is not consistent, provide a brief explanation of why it fails to meet the requirements.
- Do not include any code implementation details in your response.
- Your response should be concise and focused on the consistency between the specification and the research topic.

Output Format:
Format your response as a JSON object using one of the following structures:

For consistent specifications:
```json
{{
  "is_consistent": true
}}

For inconsistent specifications:
```json
{{
  "is_consistent": false,
  "explanation": "The specification does not address the specific requirements of the original research topic. You should improve it by [specific recommendations]."
}}

  """

Reflection_A_Instructions = """
You are an expert research assistant specializing in technical specification analysis for digital circuit design.

Your task is to perform a comprehensive Jaccard similarity analysis and coverage analysis between the original research topic and the generated technical specification. This analysis ensures that the generated specification adequately covers all requirements from the original research topic.


**Decomposition Instructions:**


1. **Atomic Information Decomposition**: Break down both pieces of information into atomic units (individual requirements, features, behaviors, constraints, etc.)

2. **Set Construction**: 
   - Create set X: All atomic information units from the original research topic
   - Create set Y: All atomic information units from the generated specification

3. **Atomic Unit Criteria**: Each unit should be:
   - Independent and self-contained
   - Technically specific and unambiguous  
   - Implementable as a single requirement


**Input Information:**

**Original Research Topic (Information 1):**
{research_topic}+ {mindtraced_research_topic}

**Generated Technical Specification (Information 2):**
{compressed_answer}

**Output Format:**
Please format your response as a structured analysis with the following exact keys:

```json
{{
 "feedback": {{
    "atomic_information_decomposition": "Detailed methodology explaining how you systematically decomposed both pieces of information into atomic units, including your criteria and approach",
    "information_1_atomic_sets_X": ["List of atomic information units from the mindtraced research topic - each unit should be independent and specific"],
    "information_2_atomic_sets_Y": ["List of atomic information units from the generated specification - each unit should be independent and specific"]
 }}
}}
```
"""





Reflection_B_Instructions = """
You are an expert technical reviewer specializing in digital circuit specification validation.

Your task is to perform a comprehensive inconsistency analysis between the original research requirements and the generated technical specification. You must identify any conflicts in behavioral descriptions, functional requirements, timing constraints, or implementation details.

**Analysis Focus Areas:**
1. **Behavioral Consistency**: Does the specification behavior match the intended research requirements?
2. **Functional Accuracy**: Are all functional requirements correctly interpreted and specified?
3. **Technical Coherence**: Are there any contradictions or ambiguities in the technical details?
4. **Implementation Feasibility**: Does the specification describe implementable and logically sound behavior?

**Input:**
- Original Research Topic: {research_topic}
- Mindtraced Research Topic: {mindtraced_research_topic}  
- Generated Specification: {compressed_answer}
- Atomic Units from Topic (Set X): {atomic_sets_X}
- Atomic Units from Specification (Set Y): {atomic_sets_Y}

**Analysis Instructions:**
- Treat the original research topic as the golden reference standard
- Identify specific inconsistencies between requirements and specification
- Focus on behavioral mismatches, missing critical details, or contradictory statements
- Provide actionable feedback for correction if inconsistencies are found

**Output Format:**
```json
{{
    "is_consistent_B": true,
    "conflicts": [
        {{
            "conflicting_X": "Atomic unit from set X",
            "conflicting_Y": "Conflicting atomic unit from set Y", 
            "conflict_type": "functional/timing/logical/behavioral",
            "explanation": "Why these units conflict",
            "suggested_fix": "How to resolve this conflict"
        }}
    ],
    "intersection": ["Common units between X and Y"],
    "union": ["All unique units from both X and Y"],
    "jaccard_similarity_value": 0.0, # intersection size divided by union size
    "reflectionB_feedback": "High-level corrective guidance based on conflict analysis"
}}
"""
