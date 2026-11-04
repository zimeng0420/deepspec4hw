# Task: hadd

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
- User: CMB
Create a half adder. A half adder adds two bits (with no carry-in) and produces a sum and carry-out.
module top_module (
	input a,
	input b,
	output sum,
	output cout
);


- Analyze Report: Top_Analyze="Analyze the module header, input ports (a, b), and output ports (sum, cout) of the half adder. Describe the expected behavior: 'sum' should represent the sum of 'a' and 'b', and 'cout' should represent the carry-out. Explain how 'a' and 'b' influence 'sum' and 'cout'." Topic_Analyze="Research the following topics and aggregate the findings: 1) Truth table for a half adder. 2) Boolean expressions for 'sum' and 'cout' in terms of 'a' and 'b'. 3) Verilog implementation of XOR gate (for 'sum'). 4) Verilog implementation of AND gate (for 'cout'). 5) Half adder applications and use cases. Ensure the research incorporates the latest information available as of September 12, 2025." Solving_Strategies="Outline a step-by-step methodology: 1) Define the truth table for a half adder. 2) Derive the Boolean expressions for 'sum' and 'cout' from the truth table. 3) Implement 'sum' using an XOR gate in Verilog. 4) Implement 'cout' using an AND gate in Verilog. 5) Combine the XOR and AND gate implementations to create the half adder module. Relate each step to the module's ports and overall functionality."

