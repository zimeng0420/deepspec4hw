# Messages for Task: lemmings1

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.The game Lemmings involves critters with fairly simple brains. So simple that we are going to model it using a finite state machine. In the Lemmings' 2D world, Lemmings can be in one of two states: walking left (walk_left is 1) or walking right (walk_right is 1). It will switch directions if it hits an obstacle. In particular, if a Lemming is bumped on the left (by receiving a 1 on bump_left), it will walk right. If it's bumped on the right (by receiving a 1 on bump_right), it will walk left. If it's bumped on both sides at the same time, it will still switch directions. Implement a Moore state machine with two states, two inputs, and one output (internal to the module) that models this behaviour. areset is positive edge triggered asynchronous reseting the Lemming machine to walk left.

Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

## User Message

```
The header you have already known is:module top_module (
	input clk,
	input areset,
	input bump_left,
	input bump_right,
	output walk_left,
	output walk_right
);


You can use the technical specification as follows:

Pure CMB Logic :
```json
{
  "header": "The top module header definition from module top_module ( input clk, input areset, input bump_left, input bump_right, output walk_left, output walk_right );, including the interface definition and their behavior.",
  
  "combinational_logic_function": "The outputs walk_left and walk_right are derived from the current state of the FSM, which can be either WALK_LEFT or WALK_RIGHT. The combinational logic is structured as follows: 1. **State Definitions**: Define two states: WALK_LEFT and WALK_RIGHT. 2. **Output Logic**: - In the WALK_LEFT state, walk_left = 1 and walk_right = 0. - In the WALK_RIGHT state, walk_left = 0 and walk_right = 1. 3. **Next State Logic**: The next state is determined based on the current state and the bump inputs: - If in WALK_LEFT and bump_left is asserted, transition to WALK_RIGHT. - If in WALK_RIGHT and bump_right is asserted, transition to WALK_LEFT. - If both bump_left and bump_right are asserted, the FSM will switch directions regardless of the current state. 4. **Truth Table**: A truth table can be constructed to summarize the state transitions and outputs based on the current state and inputs. 5. **Signal Flow Optimization**: The logic should be organized to minimize the number of gates and ensure that the critical path is as short as possible, allowing for efficient signal propagation. 6. **Output Multiplexing**: The outputs can be multiplexed based on the current state, ensuring that only one output is active at any time, thus reducing potential contention and ensuring clear signal integrity.",
  
  "enhanced_combinational_description": "Comprehensive combinational logic specification derived from User: SEQ The game Lemmings involves critters with fairly simple brains. So simple that we are going to model it using a finite state machine. In the Lemmings' 2D world, Lemmings can be in one of two states: walking left (walk_left is 1) or walking right (walk_right is 1). It will switch directions if it hits an obstacle. In particular, if a Lemming is bumped on the left (by receiving a 1 on bump_left), it will walk right. If it's bumped on the right (by receiving a 1 on bump_right), it will walk left. If it's bumped on both sides at the same time, it will still switch directions. Implement a Moore state machine with two states, two inputs, and one output (internal to the module) that models this behaviour. areset is positive edge triggered asynchronous resetting the Lemming machine to walk left. module top_module ( input clk, input areset, input bump_left, input bump_right, output walk_left, output walk_right ); The combinational logic will ensure that the outputs are determined solely by the current state of the FSM, adhering to the principles of a Moore machine. The design will include a clear state transition diagram, a state table, and a systematic approach to defining the next state and output logic based on the current state and inputs."
}
```

 With Timing Logic Summary:
```json
{
  "header": "The module 'top_module' implements a Moore finite state machine (FSM) for controlling the walking direction of Lemmings based on bump inputs. It has two states: walking left and walking right, with asynchronous reset functionality.",
  "Interface Behavior": "The module has the following ports: 'clk' (clock input), 'areset' (asynchronous reset input), 'bump_left' (input indicating a bump on the left), 'bump_right' (input indicating a bump on the right), 'walk_left' (output indicating walking left), and 'walk_right' (output indicating walking right). The outputs 'walk_left' and 'walk_right' are determined by the current state of the FSM. The 'areset' signal resets the FSM to the 'walk left' state immediately upon assertion, regardless of the clock.",
  "Timing Dependency": "The FSM transitions occur on the positive edge of the 'clk' signal, except when 'areset' is asserted. The timing characteristics are as follows: upon a positive edge of 'clk', if 'bump_left' is asserted while in the 'WALK_LEFT' state, the FSM transitions to 'WALK_RIGHT'. Conversely, if 'bump_right' is asserted while in the 'WALK_RIGHT' state, it transitions to 'WALK_LEFT'. If both bumps are asserted simultaneously, the FSM will prioritize the transition based on the defined logic.",
  "Timing logic": "The FSM consists of two registers to hold the current state, one for 'WALK_LEFT' and one for 'WALK_RIGHT'. The state transitions are implemented using non-blocking assignments within an 'always' block triggered by the 'clk' signal. The outputs 'walk_left' and 'walk_right' are derived directly from the current state, ensuring that they reflect the state of the FSM without any combinational logic delays. The asynchronous reset is implemented to immediately set the state to 'WALK_LEFT' when 'areset' is asserted."
}
```
```

