# Task: vector100r

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
Given a 100-bit input vector [99:0], reverse its bit ordering.
module top_module (
	input [99:0] in,
	output reg [99:0] out
);


- Analyze Report: Top_Analyze="Analyze the module header, input port 'in', and output port 'out'. Focus on the data width (100 bits) and the direction of bit reversal. How does the module's structure facilitate bit reversal?" Topic_Analyze='Research the following topics: 1) ' Solving_Strategies="The overall strategy involves: 1) Understanding the bit reversal operation. 2) Devising a step-by-step method to reverse the bit order. 3) Mapping the input bits to the output bits in reverse order. 4) Considering hardware implementation strategies for bit reversal. 5) Validating the bit reversal logic for correctness. Each step relates to the top_module by defining the transformation from the input 'in' to the output 'out'."

