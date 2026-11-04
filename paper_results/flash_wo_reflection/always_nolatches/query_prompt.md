# Task: always_nolatches

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
Suppose you're building a circuit to process scancodes from a PS/2 keyboard for a game. Given the last two bytes of scancodes received, you need to indicate whether one of the arrow keys on the keyboard have been pressed. This involves a fairly simple mapping, which can be implemented as a case statement (or if-elseif) with four cases.
// Scancode[15:0] | Arrow key
// 16'he06b | left arrow
// 16'he072 | down arrow
// 16'he074 | right arrow
// 16'he075 | up arrow
// Anything else | none
// Your circuit has one 16-bit input, and four outputs. Build this circuit that recognizes these four scancodes and asserts the correct output.


module top_module (
	input [15:0] scancode,
	output reg left,
	output reg down,
	output reg right,
	output reg up
);


- Analyze Report: Top_Analyze="Analyze the module header, input port 'scancode', and output ports 'left', 'down', 'right', and 'up'. Focus on how the 16-bit scancode input is mapped to the four output signals, each representing an arrow key. The module's overall behavior is to decode the scancode and assert the corresponding output." Topic_Analyze='Provide a structured analysis of the research topic by addressing the following queries: 1) "PS/2 keyboard scancode structure and arrow key codes" to understand the specific scancodes for arrow keys; 2) "Verilog implementation of case statement for scancode decoding" to find efficient ways to implement the decoding logic; 3) "handling \'e0\' prefix in PS/2 scancodes" to understand the meaning of the prefix; 4) "debouncing PS/2 keyboard input in Verilog" to address potential issues with noisy inputs; and 5) "Verilog coding style for lookup tables" to explore alternative implementations. Synthesize the findings to provide a focused analysis of the research topic, considering the date September 12, 2025.' Solving_Strategies="Outline the overall reasoning strategies and methodology: 1) Decompose the problem into identifying the correct scancodes and implementing the decoding logic. 2) Create a case statement that maps each scancode to its corresponding output. 3) Consider the 'e0' prefix and ensure it is handled correctly. 4) Implement the logic in Verilog, ensuring that the correct output is asserted for each arrow key scancode. 5) Test the implementation with different scancodes to verify its correctness."

