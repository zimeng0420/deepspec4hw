# Messages for Task: lemmings1

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.The game Lemmings involves critters with fairly simple brains. So simple that we are going to model it using a finite state machine. In the Lemmings' 2D world, Lemmings can be in one of two states: walking left (walk_left is 1) or walking right (walk_right is 1). It will switch directions if it hits an obstacle. In particular, if a Lemming is bumped on the left (by receiving a 1 on bump_left), it will walk right. If it's bumped on the right (by receiving a 1 on bump_right), it will walk left. If it's bumped on both sides at the same time, it will still switch directions. Implement a Moore state machine with two states, two inputs, and one output (internal to the module) that models this behaviour. areset is positive edge triggered asynchronous reseting the Lemming machine to walk left.

The compressed specification is as follows: Pure CMB Logic :
```json
{
  "header": "The top module header definition is:\n\nmodule top_module (\n input clk,\n input areset,\n input bump_left,\n input bump_right,\n output walk_left,\n output walk_right\n);\n\nThis module defines the interface for a Lemmings direction control circuit. The inputs `bump_left` and `bump_right` indicate collisions with obstacles on the left and right, respectively. The outputs `walk_left` and `walk_right` indicate the current walking direction of the Lemming. `clk` and `areset` are used for sequential logic, but are part of the module definition.",
  "combinational_logic_function": "The combinational logic determines the outputs `walk_left` and `walk_right` based on the current state. Since this is a Moore machine, the outputs are solely a function of the current state. Let's define the states as follows:\n\n*   State 0: Walking Left (walk_left = 1, walk_right = 0)\n*   State 1: Walking Right (walk_left = 0, walk_right = 1)\n\nThe next state logic, which is sequential, determines the state transition based on the inputs `bump_left` and `bump_right`. However, the combinational logic only maps the current state to the outputs. Therefore:\n\n*   `walk_left = (current_state == 0)`\n*   `walk_right = (current_state == 1)`\n\nThis can be implemented using simple assignment statements or a 2-to-1 multiplexer where the select signal is the `current_state`.\n\nLogic Organization:\n\n1.  **State Encoding:** The current state is encoded as a single bit (0 or 1).\n2.  **Output Generation:** The outputs `walk_left` and `walk_right` are directly derived from the current state.\n\nSignal Flow Optimization:\n\nThe signal flow is straightforward: the current state directly drives the outputs. No further optimization is needed for the combinational part.\n\nCritical Path Identification:\n\nThe critical path is the path from the state register to the outputs `walk_left` and `walk_right`. The combinational logic contributes a minimal delay, primarily due to the output assignment.\n\nOperator Sharing and Resource Utilization Strategies:\n\nNo operator sharing is applicable in this simple combinational logic.\n\nLogic Level Balancing and Delay Equalization Techniques:\n\nSince the logic is very simple, no logic level balancing or delay equalization is required.\n\nOutput Multiplexing and Selection Logic Organization:\n\nWhile not strictly a multiplexer, the output logic can be viewed as a simple decoder. If `current_state` is 0, `walk_left` is 1 and `walk_right` is 0. If `current_state` is 1, `walk_left` is 0 and `walk_right` is 1.",
  "enhanced_combinational_description": "The combinational logic within the `top_module` directly translates the current state of the Lemmings' walking direction into output signals. The Lemmings can be in one of two states: walking left or walking right. These states are represented internally, and the combinational logic is responsible for generating the `walk_left` and `walk_right` output signals based solely on the current state. The `bump_left` and `bump_right` inputs influence the *next* state, but the combinational logic only deals with the *current* state.\n\nSpecifically:\n\n*   When the Lemming is in the 'walking left' state, the `walk_left` output is asserted (set to 1), and the `walk_right` output is de-asserted (set to 0).\n*   Conversely, when the Lemming is in the 'walking right' state, the `walk_right` output is asserted, and the `walk_left` output is de-asserted.\n\nThis relationship can be expressed as follows:\n\n`walk_left = (current_state == walking_left_state);`\n`walk_right = (current_state == walking_right_state);`\n\nWhere `walking_left_state` and `walking_right_state` are symbolic representations of the two possible states. In a practical implementation, these states would be encoded using binary values (e.g., 0 and 1). The combinational logic effectively acts as a decoder, translating the binary state encoding into the appropriate output signals. The `areset` input, while part of the module definition, does not directly influence the combinational logic. It affects the initial state of the sequential logic, but the combinational logic only responds to the current state after the reset has been applied.\n\nThe combinational logic is therefore very simple and can be implemented with minimal gate delay. The primary function is to map the current state to the corresponding output signals, ensuring that only one of `walk_left` or `walk_right` is asserted at any given time, reflecting the Lemmings' current walking direction."
}
```

 With Timing Logic Summary:
```json
{
  "header": "The module `top_module` implements a Moore state machine that models the walking behavior of a Lemming. The Lemming can walk left or right, and changes direction when it encounters an obstacle (bump_left or bump_right). The `areset` signal asynchronously resets the Lemming to the walking left state.",
  "Interface Behavior": "The `areset` input asynchronously resets the state machine to the walk_left state. The `clk` input clocks the state machine. When `bump_left` is asserted, the Lemming switches to walking right. When `bump_right` is asserted, the Lemming switches to walking left. The `walk_left` and `walk_right` outputs indicate the current walking direction.",
  "Timing Dependency": "The next state logic depends on the current state (implicitly stored in the `walk_left` and `walk_right` registers) and the inputs `bump_left` and `bump_right`. The state updates on the rising edge of `clk`. The `areset` signal asynchronously resets the state, overriding the clock. There are no explicit timing values given, so we assume standard flip-flop timing characteristics (setup time, hold time, clock-to-output delay).",
  "Timing logic": "The state machine has two states, represented by the `walk_left` and `walk_right` outputs. These outputs are implemented as registers (implicitly). The state updates on the positive edge of `clk` using non-blocking assignments (inferred from the sequential nature of the problem). The `areset` signal provides an asynchronous reset. The number of registers is two (one for `walk_left` and one for `walk_right`)."
}
```

The header you have already known is:module top_module (
	input clk,
	input areset,
	input bump_left,
	input bump_right,
	output walk_left,
	output walk_right
);


Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

