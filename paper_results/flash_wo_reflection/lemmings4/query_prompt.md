# Task: lemmings4

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
The game Lemmings involves critters with fairly simple brains. So simple that we are going to model it using a finite state machine. In the Lemmings' 2D world, Lemmings can be in one of two states: walking left (walk_left is 1) or walking right (walk_right is 1). It will switch directions if it hits an obstacle. In particular, if a Lemming is bumped on the left (by receiving a 1 on bump_left), it will walk right. If it's bumped on the right (by receiving a 1 on bump_right), it will walk left. If it's bumped on both sides at the same time, it will still switch directions. 
// In addition to walking left and right and changing direction when bumped, when ground=0, the Lemming will fall and say ""aaah!"". When the ground reappears (ground=1), the Lemming will resume walking in the same direction as before the fall. Being bumped while falling does not affect the walking direction, and being bumped in the same cycle as ground disappears (but not yet falling), or when the ground reappears while still falling, also does not affect the walking direction.
// In addition to walking and falling, Lemmings can sometimes be told to do useful things, like dig (it starts digging when dig=1). A Lemming can dig if it is currently walking on ground (ground=1 and not falling), and will continue digging until it reaches the other side (ground=0). At that point, since there is no ground, it will fall (aaah!), then continue walking in its original direction once it hits ground again. As with falling, being bumped while digging has no effect, and being told to dig when falling or when there is no ground is ignored. (In other words, a walking Lemming can fall, dig, or switch directions. If more than one of these conditions are satisfied, fall has higher precedence than dig, which has higher precedence than switching directions.)
// Although Lemmings can walk, fall, and dig, Lemmings aren't invulnerable. If a Lemming falls for too long then hits the ground, it can splatter. In particular, if a Lemming falls for more than 20 clock cycles then hits the ground, it will splatter and cease walking, falling, or digging (all 4 outputs become 0), forever (Or until the FSM gets reset). There is no upper limit on how far a Lemming can fall before hitting the ground. Lemmings only splatter when hitting the ground; they do not splatter in mid-air.
// Implement a Moore state machine that models this behaviour. areset is positive edge triggered asynchronous reseting the Lemming machine to walk left.
module top_module (
	input clk,
	input areset,
	input bump_left,
	input bump_right,
	input ground,
	input dig,
	output walk_left,
	output walk_right,
	output aaah,
	output digging
);


- Analyze Report: Top_Analyze="Analyze the Verilog module 'top_module' for the Lemmings FSM. Focus on the input ports (clk, areset, bump_left, bump_right, ground, dig) and output ports (walk_left, walk_right, aaah, digging). Describe how each input affects the Lemming's state and outputs, and how the outputs reflect the Lemming's current state. Pay close attention to the precedence of fall, dig, and direction changes. Note the asynchronous reset behavior." Topic_Analyze="Provide a structured analysis of the Lemmings FSM, covering the following topics: 1) State transition logic based on 'bump_left' and 'bump_right' inputs. 2) Falling behavior when 'ground' is 0, including the 'aaah' output and resuming walking. 3) Digging behavior when 'dig' is 1 and 'ground' is 1, including the transition to falling. 4) Splattering condition when falling for more than 20 clock cycles. 5) Moore machine implementation details. Research and incorporate the latest information available as of September 12, 2025, on best practices for implementing Moore state machines in Verilog, especially regarding asynchronous resets and handling multiple concurrent conditions." Solving_Strategies="Outline the following reasoning strategies: 1) Decompose the problem into state transitions for walking, falling, digging, and splattering. 2) Define the state variables needed to track the Lemming's state (walking direction, falling duration, digging status, etc.). 3) Create a state transition diagram or table showing all possible transitions based on the inputs. 4) Implement the Moore machine logic in Verilog, ensuring correct precedence of fall, dig, and direction changes. 5) Handle the asynchronous reset and splattering condition correctly. 6) Verify the implementation with test cases covering all possible scenarios. 7) Refine the Verilog code based on simulation results and best practices for Moore machine implementation."

