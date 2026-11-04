# Task: rule90

## Prompt to Generate Queries

Your goal is to generate sophisticated and diverse search queries. These queries are intended for an advanced automated web research tool capable of analyzing complex results, following links, and synthesizing information.

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
{
    "query": ["What is one-hot encoding in finite state machines?", "How are next-state signals derived in a one-hot encoded FSM?", "What do the inputs y[6:1] and w represent in the FSM?"],

    "rationale": "To answer this comparative growth question accurately, Understanding how one-hot encoding represents states and how inputs like y[6:1] and w influence transitions is essential for correctly deriving next-state logic in a finite state machine. These concepts form the foundation for interpreting and implementing FSM behavior in Verilog.",
}    
```

Context: 
- User: SEQ
Rule 90 is a one-dimensional cellular automaton with interesting properties. The rules are simple. There is a one-dimensional array of cells (on or off). At each time step, the next state of each cell is the XOR of the cell's two current neighbours:
// Left | Center | Right | Center's next state
// 1 | 1 | 1 | 0
// 1 | 1 | 0 | 1
// 1 | 0 | 1 | 0
// 1 | 0 | 0 | 1
// 0 | 1 | 1 | 1
// 0 | 1 | 0 | 0 
// 0 | 0 | 1 | 1
// 0 | 0 | 0 | 0
// In this circuit, create a 512-cell system (q[511:0]), and advance by one time step each clock cycle. The load input indicates the state of the system should be loaded with data[511:0]. Assume the boundaries (q[-1] and q[512]) are both zero (off).
module top_module(
	input clk,
	input load,
	input [511:0] data,
	output reg [511:0] q);


- Analyze Report: Top_Analyze="Analyze the module header and ports: clk, load, data[511:0], and q[511:0]. Describe the overall behavior of the Rule 90 cellular automaton, focusing on how the inputs influence the output q. Specifically, detail how the 'load' signal affects the system's state and how the 'clk' signal advances the simulation. Note the boundary conditions (q[-1] and q[512] are zero)." Topic_Analyze='Provide a structured analysis of Rule 90 cellular automata, focusing on its implementation in hardware (Verilog). Research the following: 1) Rule 90 definition and properties; 2) XOR-based implementation of Rule 90; 3) Implementation of boundary conditions in cellular automata; 4) Parallel implementation of cellular automata; 5) Verilog implementation of Rule 90 cellular automata with load functionality. Ensure the analysis includes the latest research findings as of September 12, 2025.' Solving_Strategies="Outline the overall reasoning strategies and methodology: 1) Understand the Rule 90 algorithm and its XOR-based implementation. 2) Design the circuit to implement the Rule 90 update rule for each cell. 3) Implement the boundary conditions by treating the neighbors of the boundary cells as zero. 4) Implement the load functionality to initialize the cellular automaton with the input data. 5) Use clock signal to advance the simulation by one time step. 6) Verify the Verilog implementation using simulation. Each step should relate to the module's inputs, outputs, and internal state."

