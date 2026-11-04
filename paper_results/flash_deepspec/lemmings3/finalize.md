#  Task: lemmings3

## CMB Logic Prompt

```
Generate a high-quality technical specification for a combinational logic circuit based on the provided summaries.

Instructions:

- Your goal is to focus exclusively on the combinational logic aspects of the task and generate a comprehensive technical specification for a pure combinational logic design.
- Your report should serve as a comprehensive technical specification for pure combinational logic implementation.
- No words about sequential logic or timing analysis.
- No words about resource utilization or optimization.
- No words about clock frequencies or timing constraints.
- Do not include any code implementation details or formal verification steps in your response.
Available Information:

- RTL Top Module Header: 
- Analyze Report: None
- Original Task Description: User: SEQ
The game Lemmings involves critters with fairly simple brains. So simple that we are going to model it using a finite state machine. In the Lemmings' 2D world, Lemmings can be in one of two states: walking left (walk_left is 1) or walking right (walk_right is 1). It will switch directions if it hits an obstacle. In particular, if a Lemming is bumped on the left (by receiving a 1 on bump_left), it will walk right. If it's bumped on the right (by receiving a 1 on bump_right), it will walk left. If it's bumped on both sides at the same time, it will still switch directions. 
// In addition to walking left and right and changing direction when bumped, when ground=0, the Lemming will fall and say "aaah!". When the ground reappears (ground=1), the Lemming will resume walking in the same direction as before the fall. Being bumped while falling does not affect the walking direction, and being bumped in the same cycle as ground disappears (but not yet falling), or when the ground reappears while still falling, also does not affect the walking direction.
// In addition to walking and falling, Lemmings can sometimes be told to do useful things, like dig (it starts digging when dig=1). A Lemming can dig if it is currently walking on ground (ground=1 and not falling), and will continue digging until it reaches the other side (ground=0). At that point, since there is no ground, it will fall (aaah!), then continue walking in its original direction once it hits ground again. As with falling, being bumped while digging has no effect, and being told to dig when falling or when there is no ground is ignored. (In other words, a walking Lemming can fall, dig, or switch directions. If more than one of these conditions are satisfied, fall has higher precedence than dig, which has higher precedence than switching directions.)
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


- Others:

Output Format:
Format your response as a JSON object with the following structure:

```json
{
  "header": "The top module header definition from , including the interface definition and their behavior.",

  "combinational_logic_function": "Describe how outputs derive from inputs (e.g., Boolean expressions, truth table patterns). Provide a systematic breakdown of the combinational logic structure optimized for performance and area. Include: logic organization with clear functional boundaries, signal flow optimization and critical path identification, operator sharing and resource utilization strategies, logic level balancing and delay equalization techniques, output multiplexing and selection logic organization.",

  "enhanced_combinational_description": "Comprehensive combinational logic specification derived from User: SEQ
The game Lemmings involves critters with fairly simple brains. So simple that we are going to model it using a finite state machine. In the Lemmings' 2D world, Lemmings can be in one of two states: walking left (walk_left is 1) or walking right (walk_right is 1). It will switch directions if it hits an obstacle. In particular, if a Lemming is bumped on the left (by receiving a 1 on bump_left), it will walk right. If it's bumped on the right (by receiving a 1 on bump_right), it will walk left. If it's bumped on both sides at the same time, it will still switch directions. 
// In addition to walking left and right and changing direction when bumped, when ground=0, the Lemming will fall and say "aaah!". When the ground reappears (ground=1), the Lemming will resume walking in the same direction as before the fall. Being bumped while falling does not affect the walking direction, and being bumped in the same cycle as ground disappears (but not yet falling), or when the ground reappears while still falling, also does not affect the walking direction.
// In addition to walking and falling, Lemmings can sometimes be told to do useful things, like dig (it starts digging when dig=1). A Lemming can dig if it is currently walking on ground (ground=1 and not falling), and will continue digging until it reaches the other side (ground=0). At that point, since there is no ground, it will fall (aaah!), then continue walking in its original direction once it hits ground again. As with falling, being bumped while digging has no effect, and being told to dig when falling or when there is no ground is ignored. (In other words, a walking Lemming can fall, dig, or switch directions. If more than one of these conditions are satisfied, fall has higher precedence than dig, which has higher precedence than switching directions.)
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

. All details must be comprehensive and tailored for LLM models."
}






```

## CMB Logic Summary

```
```json
{
  "header": "module top_module (\n input clk,\n input areset,\n input bump_left,\n input bump_right,\n input ground,\n input dig,\n output walk_left,\n output walk_right,\n output aaah,\n output digging\n);",
  "combinational_logic_function": "The outputs `walk_left`, `walk_right`, `aaah`, and `digging` are derived from the inputs `bump_left`, `bump_right`, `ground`, and `dig`, as well as the current state of the Lemming. The combinational logic determines the next state and the current outputs based on these inputs and the current state. The precedence of actions is fall > dig > switch directions. \n\n*   **aaah Output:** `aaah` is asserted (1) when the Lemming is falling (ground = 0). Therefore, `aaah = !ground`.\n*   **digging Output:** `digging` is asserted (1) when the Lemming is digging. The Lemming digs only when `ground = 1` and `dig = 1` and it is not falling. Therefore, `digging = ground & dig & !(!ground)` which simplifies to `digging = ground & dig`.\n*   **walk_left and walk_right Outputs:** These outputs depend on the current walking direction and whether the Lemming is bumped. If the Lemming is bumped, it switches direction. If the Lemming is falling or digging, the walking direction remains unchanged. The combinational logic for these outputs involves determining the next walking direction based on the current direction and the bump inputs. Let's denote the current walking direction as `current_walk_left` and `current_walk_right`. The next walking direction is determined as follows:\n    *   If `bump_left` or `bump_right` is asserted, the Lemming switches direction. If both are asserted, it still switches direction.\n    *   If `ground = 0` (falling) or `digging = 1`, the walking direction remains the same.\n    *   If none of the above conditions are met, the walking direction remains the same.\n\nTherefore, the combinational logic for `walk_left` and `walk_right` can be expressed as:\n\n`walk_left = (current_walk_right & !(bump_left | bump_right)) | (current_walk_left & (bump_left | bump_right))`\n`walk_right = (current_walk_left & !(bump_left | bump_right)) | (current_walk_right & (bump_left | bump_right))`\n\nHowever, since the Lemming is falling or digging, the walking direction remains unchanged. Therefore, the combinational logic for `walk_left` and `walk_right` can be expressed as:\n\n`walk_left = (current_walk_left & (ground | !digging)) | (current_walk_right & (bump_left | bump_right) & (ground | !digging))`\n`walk_right = (current_walk_right & (ground | !digging)) | (current_walk_left & (bump_left | bump_right) & (ground | !digging))`\n\nSince `digging = ground & dig`, the combinational logic for `walk_left` and `walk_right` can be expressed as:\n\n`walk_left = (current_walk_left & (ground | !(ground & dig))) | (current_walk_right & (bump_left | bump_right) & (ground | !(ground & dig)))`\n`walk_right = (current_walk_right & (ground | !(ground & dig))) | (current_walk_left & (bump_left | bump_right) & (ground | !(ground & dig)))`\n\nThese expressions can be further simplified using Boolean algebra. The critical path is likely through the logic that determines `walk_left` and `walk_right`, as it involves multiple AND and OR operations. Operator sharing can be used to reduce the area by sharing common sub-expressions. Logic level balancing can be used to equalize the delay through different paths. Output multiplexing can be used to select the appropriate output based on the current state.",
  "enhanced_combinational_description": "This specification details the combinational logic required to implement the Lemmings behavior described in the original task. The Lemmings can walk left or right, fall, and dig. The outputs `walk_left`, `walk_right`, `aaah`, and `digging` are determined by the inputs `bump_left`, `bump_right`, `ground`, and `dig`, and the current state of the Lemming (walking direction). The precedence of actions is fall > dig > switch directions.\n\n1.  **aaah Output:**\n    *   The `aaah` output is asserted (set to 1) when the Lemming is falling. This occurs when `ground` is 0.\n    *   Boolean expression: `aaah = !ground`\n\n2.  **digging Output:**\n    *   The `digging` output is asserted when the Lemming is digging. The Lemming digs only when it is on the ground (`ground = 1`), the `dig` input is asserted (`dig = 1`), and it is not falling (`ground = 1`).\n    *   Boolean expression: `digging = ground & dig`\n\n3.  **walk_left and walk_right Outputs:**\n    *   These outputs determine the direction the Lemming is walking. Only one of these outputs can be asserted at any given time.\n    *   The Lemming changes direction when it encounters an obstacle (`bump_left` or `bump_right` is asserted).\n    *   Falling and digging take precedence over changing direction. When the Lemming is falling or digging, the walking direction remains unchanged.\n    *   Let `current_walk_left` and `current_walk_right` represent the current walking direction. The next walking direction is determined as follows:\n        *   If the Lemming is falling (`!ground`), the walking direction remains the same.\n        *   If the Lemming is digging (`ground & dig`), the walking direction remains the same.\n        *   If the Lemming is bumped (`bump_left | bump_right`), the Lemming switches direction.\n        *   Otherwise, the walking direction remains the same.\n    *   The combinational logic for `walk_left` and `walk_right` can be expressed as:\n\n    `walk_left = (current_walk_left & !(bump_left | bump_right) & ground & !dig) | (current_walk_right & (bump_left | bump_right) & ground & !dig) | (current_walk_left & !ground) | (current_walk_left & ground & dig)`\n    `walk_right = (current_walk_right & !(bump_left | bump_right) & ground & !dig) | (current_walk_left & (bump_left | bump_right) & ground & !dig) | (current_walk_right & !ground) | (current_walk_right & ground & dig)`\n\n    *   These expressions can be simplified using Boolean algebra. The terms `!ground` and `ground & dig` ensure that the walking direction remains unchanged when the Lemming is falling or digging, respectively. The terms `(bump_left | bump_right)` cause the Lemming to switch direction when bumped, but only if it is not falling or digging.\n\nThis specification provides a complete description of the combinational logic required to implement the Lemmings behavior. The Boolean expressions can be directly translated into a hardware implementation using logic gates."
}
```
```

## Mindtrace Prompt

```
You are a senior hardware engineer with expertise in analyzing and clarifying ambiguous technical specifications.


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
User: SEQ
The game Lemmings involves critters with fairly simple brains. So simple that we are going to model it using a finite state machine. In the Lemmings' 2D world, Lemmings can be in one of two states: walking left (walk_left is 1) or walking right (walk_right is 1). It will switch directions if it hits an obstacle. In particular, if a Lemming is bumped on the left (by receiving a 1 on bump_left), it will walk right. If it's bumped on the right (by receiving a 1 on bump_right), it will walk left. If it's bumped on both sides at the same time, it will still switch directions. 
// In addition to walking left and right and changing direction when bumped, when ground=0, the Lemming will fall and say "aaah!". When the ground reappears (ground=1), the Lemming will resume walking in the same direction as before the fall. Being bumped while falling does not affect the walking direction, and being bumped in the same cycle as ground disappears (but not yet falling), or when the ground reappears while still falling, also does not affect the walking direction.
// In addition to walking and falling, Lemmings can sometimes be told to do useful things, like dig (it starts digging when dig=1). A Lemming can dig if it is currently walking on ground (ground=1 and not falling), and will continue digging until it reaches the other side (ground=0). At that point, since there is no ground, it will fall (aaah!), then continue walking in its original direction once it hits ground again. As with falling, being bumped while digging has no effect, and being told to dig when falling or when there is no ground is ignored. (In other words, a walking Lemming can fall, dig, or switch directions. If more than one of these conditions are satisfied, fall has higher precedence than dig, which has higher precedence than switching directions.)
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



OUTPUT FORMAT:  
Return a valid JSON object following the structure below:  

{
  "mindtrace_schemas": [
    {
      "original_text": "Exact quote from the research topic that contains misleading or unclear information",
      "misleading_rationale": "Detailed explanation of why this text is misleading, incomplete, or ambiguous",
      "corrected_inference": "Accurate inference or interpretation that clarifies the intended meaning and makes the reasoning explicit",
      "confidence_level": "Value between 0 and 1 indicating certainty of the correction (e.g., 0.85)"
    }
  ],
  "mindtraced_research_topic": "The unambiguous and clear CoT of the given research topic"
}

```

## Mindtraced Research Topic

```
The game Lemmings involves critters that can be modeled using a finite state machine. The Lemming can be in one of several states: walking left, walking right, falling, or digging.

Walking:
When walking, the Lemming moves either left or right. The outputs 'walk_left' and 'walk_right' indicate the direction of movement (walk_left=1, walk_right=0 for walking left; walk_left=0, walk_right=1 for walking right).

Bumping:
When a Lemming is bumped while walking on the ground, it switches direction. If bumped on the left (bump_left=1), it starts walking right. If bumped on the right (bump_right=1), it starts walking left. If bumped on both sides, it also switches direction. The bump inputs are ignored when the Lemming is falling or digging.

Falling:
When the ground disappears (ground=0), the Lemming starts falling (aaah=1, walk_left=0, walk_right=0). The Lemming continues to fall until the ground reappears (ground=1), at which point it stops falling (aaah=0) and resumes walking in the same direction it was walking before the fall. Bumping during the fall has no effect on the walking direction.

Digging:
When the 'dig' input is 1 and the Lemming is walking on the ground (ground=1 and not falling), the Lemming starts digging (digging=1, walk_left=0, walk_right=0). The Lemming continues digging until it reaches the other side (ground=0), at which point it starts falling (aaah=1, digging=0). Once the ground reappears (ground=1), the Lemming stops falling (aaah=0) and resumes walking in its original direction. The 'dig' input is ignored when the Lemming is falling or when there is no ground.

Precedence:
If multiple conditions are met simultaneously, the Lemming prioritizes actions in the following order: falling, digging, switching directions.

Reset:
The 'areset' input is a positive edge-triggered asynchronous reset. When 'areset' is asserted, the state machine resets to the walking left state (walk_left=1, walk_right=0, aaah=0, digging=0).
```

## Timing Logic Prompt

```


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

- research_topic: User: SEQ
The game Lemmings involves critters with fairly simple brains. So simple that we are going to model it using a finite state machine. In the Lemmings' 2D world, Lemmings can be in one of two states: walking left (walk_left is 1) or walking right (walk_right is 1). It will switch directions if it hits an obstacle. In particular, if a Lemming is bumped on the left (by receiving a 1 on bump_left), it will walk right. If it's bumped on the right (by receiving a 1 on bump_right), it will walk left. If it's bumped on both sides at the same time, it will still switch directions. 
// In addition to walking left and right and changing direction when bumped, when ground=0, the Lemming will fall and say "aaah!". When the ground reappears (ground=1), the Lemming will resume walking in the same direction as before the fall. Being bumped while falling does not affect the walking direction, and being bumped in the same cycle as ground disappears (but not yet falling), or when the ground reappears while still falling, also does not affect the walking direction.
// In addition to walking and falling, Lemmings can sometimes be told to do useful things, like dig (it starts digging when dig=1). A Lemming can dig if it is currently walking on ground (ground=1 and not falling), and will continue digging until it reaches the other side (ground=0). At that point, since there is no ground, it will fall (aaah!), then continue walking in its original direction once it hits ground again. As with falling, being bumped while digging has no effect, and being told to dig when falling or when there is no ground is ignored. (In other words, a walking Lemming can fall, dig, or switch directions. If more than one of these conditions are satisfied, fall has higher precedence than dig, which has higher precedence than switching directions.)
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


- mindtraced_research_topic: The game Lemmings involves critters that can be modeled using a finite state machine. The Lemming can be in one of several states: walking left, walking right, falling, or digging.

Walking:
When walking, the Lemming moves either left or right. The outputs 'walk_left' and 'walk_right' indicate the direction of movement (walk_left=1, walk_right=0 for walking left; walk_left=0, walk_right=1 for walking right).

Bumping:
When a Lemming is bumped while walking on the ground, it switches direction. If bumped on the left (bump_left=1), it starts walking right. If bumped on the right (bump_right=1), it starts walking left. If bumped on both sides, it also switches direction. The bump inputs are ignored when the Lemming is falling or digging.

Falling:
When the ground disappears (ground=0), the Lemming starts falling (aaah=1, walk_left=0, walk_right=0). The Lemming continues to fall until the ground reappears (ground=1), at which point it stops falling (aaah=0) and resumes walking in the same direction it was walking before the fall. Bumping during the fall has no effect on the walking direction.

Digging:
When the 'dig' input is 1 and the Lemming is walking on the ground (ground=1 and not falling), the Lemming starts digging (digging=1, walk_left=0, walk_right=0). The Lemming continues digging until it reaches the other side (ground=0), at which point it starts falling (aaah=1, digging=0). Once the ground reappears (ground=1), the Lemming stops falling (aaah=0) and resumes walking in its original direction. The 'dig' input is ignored when the Lemming is falling or when there is no ground.

Precedence:
If multiple conditions are met simultaneously, the Lemming prioritizes actions in the following order: falling, digging, switching directions.

Reset:
The 'areset' input is a positive edge-triggered asynchronous reset. When 'areset' is asserted, the state machine resets to the walking left state (walk_left=1, walk_right=0, aaah=0, digging=0).
- others optional: 

Output Format:
```json
{
  "header": "header of the given task",
  "Interface Behavior": "Specific port timing characteristics with exact moments",
  "Timing Dependency": "Critical paths with specific signal names and timing values",
  "Timing logic": "PURE Timing logic & behavior analysis while taking combinational logic as black boxes",

}
```


```

## Timing Logic Summary

```
```json
{
  "header": "The module `top_module` models the behavior of a Lemming in a 2D world. The Lemming can walk left, walk right, fall, or dig. The module has inputs for clock (`clk`), asynchronous reset (`areset`), bump sensors (`bump_left`, `bump_right`), ground detection (`ground`), and a dig command (`dig`). The outputs indicate the Lemming's actions: `walk_left`, `walk_right`, `aaah` (falling), and `digging`.",
  "Interface Behavior": "The `areset` input asynchronously resets the state machine to the walking left state on the positive edge. The `clk` input clocks the sequential logic. The `bump_left`, `bump_right`, `ground`, and `dig` inputs affect the state transitions based on the current state and the specified precedence rules. The outputs `walk_left`, `walk_right`, `aaah`, and `digging` reflect the current state of the Lemming and are updated on the rising edge of `clk`.",
  "Timing Dependency": "The next state logic depends on the current state (implicitly stored in registers for `walk_left`, `walk_right`, `aaah`, and `digging`) and the inputs `bump_left`, `bump_right`, `ground`, and `dig`. The critical path would involve the combinational logic that determines the next state based on these inputs, followed by the setup time of the registers. The asynchronous reset `areset` bypasses the clock and immediately sets the state to walking left.",
  "Timing logic": "This is a sequential circuit with four state variables (implicitly defined by the outputs `walk_left`, `walk_right`, `aaah`, and `digging`), which are likely implemented using registers. The state transitions occur on the rising edge of the `clk` signal. The `areset` signal provides an asynchronous reset capability. The state updates are likely implemented using non-blocking assignments (`<=`) within an `always @(posedge clk or posedge areset)` block. The number of registers is likely 4, one for each output. The clock edge is positive. The assignments to the outputs are likely non-blocking."
}
```
```

## Final Answer

```
Pure CMB Logic :
```json
{
  "header": "module top_module (\n input clk,\n input areset,\n input bump_left,\n input bump_right,\n input ground,\n input dig,\n output walk_left,\n output walk_right,\n output aaah,\n output digging\n);",
  "combinational_logic_function": "The outputs `walk_left`, `walk_right`, `aaah`, and `digging` are derived from the inputs `bump_left`, `bump_right`, `ground`, and `dig`, as well as the current state of the Lemming. The combinational logic determines the next state and the current outputs based on these inputs and the current state. The precedence of actions is fall > dig > switch directions. \n\n*   **aaah Output:** `aaah` is asserted (1) when the Lemming is falling (ground = 0). Therefore, `aaah = !ground`.\n*   **digging Output:** `digging` is asserted (1) when the Lemming is digging. The Lemming digs only when `ground = 1` and `dig = 1` and it is not falling. Therefore, `digging = ground & dig & !(!ground)` which simplifies to `digging = ground & dig`.\n*   **walk_left and walk_right Outputs:** These outputs depend on the current walking direction and whether the Lemming is bumped. If the Lemming is bumped, it switches direction. If the Lemming is falling or digging, the walking direction remains unchanged. The combinational logic for these outputs involves determining the next walking direction based on the current direction and the bump inputs. Let's denote the current walking direction as `current_walk_left` and `current_walk_right`. The next walking direction is determined as follows:\n    *   If `bump_left` or `bump_right` is asserted, the Lemming switches direction. If both are asserted, it still switches direction.\n    *   If `ground = 0` (falling) or `digging = 1`, the walking direction remains the same.\n    *   If none of the above conditions are met, the walking direction remains the same.\n\nTherefore, the combinational logic for `walk_left` and `walk_right` can be expressed as:\n\n`walk_left = (current_walk_right & !(bump_left | bump_right)) | (current_walk_left & (bump_left | bump_right))`\n`walk_right = (current_walk_left & !(bump_left | bump_right)) | (current_walk_right & (bump_left | bump_right))`\n\nHowever, since the Lemming is falling or digging, the walking direction remains unchanged. Therefore, the combinational logic for `walk_left` and `walk_right` can be expressed as:\n\n`walk_left = (current_walk_left & (ground | !digging)) | (current_walk_right & (bump_left | bump_right) & (ground | !digging))`\n`walk_right = (current_walk_right & (ground | !digging)) | (current_walk_left & (bump_left | bump_right) & (ground | !digging))`\n\nSince `digging = ground & dig`, the combinational logic for `walk_left` and `walk_right` can be expressed as:\n\n`walk_left = (current_walk_left & (ground | !(ground & dig))) | (current_walk_right & (bump_left | bump_right) & (ground | !(ground & dig)))`\n`walk_right = (current_walk_right & (ground | !(ground & dig))) | (current_walk_left & (bump_left | bump_right) & (ground | !(ground & dig)))`\n\nThese expressions can be further simplified using Boolean algebra. The critical path is likely through the logic that determines `walk_left` and `walk_right`, as it involves multiple AND and OR operations. Operator sharing can be used to reduce the area by sharing common sub-expressions. Logic level balancing can be used to equalize the delay through different paths. Output multiplexing can be used to select the appropriate output based on the current state.",
  "enhanced_combinational_description": "This specification details the combinational logic required to implement the Lemmings behavior described in the original task. The Lemmings can walk left or right, fall, and dig. The outputs `walk_left`, `walk_right`, `aaah`, and `digging` are determined by the inputs `bump_left`, `bump_right`, `ground`, and `dig`, and the current state of the Lemming (walking direction). The precedence of actions is fall > dig > switch directions.\n\n1.  **aaah Output:**\n    *   The `aaah` output is asserted (set to 1) when the Lemming is falling. This occurs when `ground` is 0.\n    *   Boolean expression: `aaah = !ground`\n\n2.  **digging Output:**\n    *   The `digging` output is asserted when the Lemming is digging. The Lemming digs only when it is on the ground (`ground = 1`), the `dig` input is asserted (`dig = 1`), and it is not falling (`ground = 1`).\n    *   Boolean expression: `digging = ground & dig`\n\n3.  **walk_left and walk_right Outputs:**\n    *   These outputs determine the direction the Lemming is walking. Only one of these outputs can be asserted at any given time.\n    *   The Lemming changes direction when it encounters an obstacle (`bump_left` or `bump_right` is asserted).\n    *   Falling and digging take precedence over changing direction. When the Lemming is falling or digging, the walking direction remains unchanged.\n    *   Let `current_walk_left` and `current_walk_right` represent the current walking direction. The next walking direction is determined as follows:\n        *   If the Lemming is falling (`!ground`), the walking direction remains the same.\n        *   If the Lemming is digging (`ground & dig`), the walking direction remains the same.\n        *   If the Lemming is bumped (`bump_left | bump_right`), the Lemming switches direction.\n        *   Otherwise, the walking direction remains the same.\n    *   The combinational logic for `walk_left` and `walk_right` can be expressed as:\n\n    `walk_left = (current_walk_left & !(bump_left | bump_right) & ground & !dig) | (current_walk_right & (bump_left | bump_right) & ground & !dig) | (current_walk_left & !ground) | (current_walk_left & ground & dig)`\n    `walk_right = (current_walk_right & !(bump_left | bump_right) & ground & !dig) | (current_walk_left & (bump_left | bump_right) & ground & !dig) | (current_walk_right & !ground) | (current_walk_right & ground & dig)`\n\n    *   These expressions can be simplified using Boolean algebra. The terms `!ground` and `ground & dig` ensure that the walking direction remains unchanged when the Lemming is falling or digging, respectively. The terms `(bump_left | bump_right)` cause the Lemming to switch direction when bumped, but only if it is not falling or digging.\n\nThis specification provides a complete description of the combinational logic required to implement the Lemmings behavior. The Boolean expressions can be directly translated into a hardware implementation using logic gates."
}
```

 With Timing Logic Summary:
```json
{
  "header": "The module `top_module` models the behavior of a Lemming in a 2D world. The Lemming can walk left, walk right, fall, or dig. The module has inputs for clock (`clk`), asynchronous reset (`areset`), bump sensors (`bump_left`, `bump_right`), ground detection (`ground`), and a dig command (`dig`). The outputs indicate the Lemming's actions: `walk_left`, `walk_right`, `aaah` (falling), and `digging`.",
  "Interface Behavior": "The `areset` input asynchronously resets the state machine to the walking left state on the positive edge. The `clk` input clocks the sequential logic. The `bump_left`, `bump_right`, `ground`, and `dig` inputs affect the state transitions based on the current state and the specified precedence rules. The outputs `walk_left`, `walk_right`, `aaah`, and `digging` reflect the current state of the Lemming and are updated on the rising edge of `clk`.",
  "Timing Dependency": "The next state logic depends on the current state (implicitly stored in registers for `walk_left`, `walk_right`, `aaah`, and `digging`) and the inputs `bump_left`, `bump_right`, `ground`, and `dig`. The critical path would involve the combinational logic that determines the next state based on these inputs, followed by the setup time of the registers. The asynchronous reset `areset` bypasses the clock and immediately sets the state to walking left.",
  "Timing logic": "This is a sequential circuit with four state variables (implicitly defined by the outputs `walk_left`, `walk_right`, `aaah`, and `digging`), which are likely implemented using registers. The state transitions occur on the rising edge of the `clk` signal. The `areset` signal provides an asynchronous reset capability. The state updates are likely implemented using non-blocking assignments (`<=`) within an `always @(posedge clk or posedge areset)` block. The number of registers is likely 4, one for each output. The clock edge is positive. The assignments to the outputs are likely non-blocking."
}
```
```

