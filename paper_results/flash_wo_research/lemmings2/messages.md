# Messages for Task: lemmings2

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.The game Lemmings involves critters with fairly simple brains. So simple that we are going to model it using a finite state machine. In the Lemmings' 2D world, Lemmings can be in one of two states: walking left (walk_left is 1) or walking right (walk_right is 1). It will switch directions if it hits an obstacle. In particular, if a Lemming is bumped on the left (by receiving a 1 on bump_left), it will walk right. If it's bumped on the right (by receiving a 1 on bump_right), it will walk left. If it's bumped on both sides at the same time, it will still switch directions. 
// In addition to walking left and right and changing direction when bumped, when ground=0, the Lemming will fall and say "aaah!". When the ground reappears (ground=1), the Lemming will resume walking in the same direction as before the fall. Being bumped while falling does not affect the walking direction, and being bumped in the same cycle as ground disappears (but not yet falling), or when the ground reappears while still falling, also does not affect the walking direction.
// Implement a Moore state machine that models this behaviour. areset is positive edge triggered asynchronous reseting the Lemming machine to walk left.

The compressed specification is as follows: Pure CMB Logic :
```json
{
  "header": "module top_module (\n\tinput clk,\n\tinput areset,\n\tinput bump_left,\n\tinput bump_right,\n\tinput ground,\n\toutput walk_left,\n\toutput walk_right,\n\toutput aaah\n);",
  "combinational_logic_function": "The output 'aaah' is asserted (1) when 'ground' is 0, and de-asserted (0) when 'ground' is 1. This can be directly implemented with an inverter.  Therefore, aaah = ~ground. The outputs 'walk_left' and 'walk_right' are determined by the current state of the Lemming. The next state logic, which is sequential, determines the values of 'walk_left' and 'walk_right' based on the inputs 'bump_left', 'bump_right', and 'ground'. However, the *current* values of 'walk_left' and 'walk_right' are outputs of the state register. The combinational logic for 'aaah' is simply an inverter.",
  "enhanced_combinational_description": "The combinational logic component of this system consists solely of the logic that determines the 'aaah' output. The 'aaah' output is asserted (logic high, or '1') when the 'ground' input is de-asserted (logic low, or '0'), indicating that the Lemming is falling. Conversely, 'aaah' is de-asserted (logic low, or '0') when 'ground' is asserted (logic high, or '1'), indicating that the Lemming is on the ground. This relationship can be expressed by the following Boolean equation: aaah = NOT(ground). This is implemented using a single inverter gate. The inputs 'bump_left' and 'bump_right' do not directly influence the combinational logic for 'aaah'. The outputs 'walk_left' and 'walk_right' are state variables and are not directly determined by combinational logic based on the inputs. They are outputs of the state register. Therefore, the only combinational logic required is an inverter for the 'aaah' output."
}
```

 With Timing Logic Summary:
```json
{
  "header": "The module `top_module` models a Lemming's movement in a 2D world. It has inputs for clock (`clk`), asynchronous reset (`areset`), bump sensors (`bump_left`, `bump_right`), and ground detection (`ground`). It has outputs indicating the Lemming's walking direction (`walk_left`, `walk_right`) and a falling signal (`aaah`).",
  "Interface Behavior": "The `areset` input asynchronously resets the state machine to the 'walk_left' state on a positive edge. The `clk` input clocks the sequential logic. `bump_left` and `bump_right` affect the walking direction. `ground` controls the `aaah` output and influences the walking state when it reappears. Bumps are ignored during the falling state and during the same cycle as ground disappearing or reappearing.",
  "Timing Dependency": "The next state logic depends on the current state (walking direction), `bump_left`, `bump_right`, and `ground`. The `aaah` output depends directly on the `ground` input. The reset signal `areset` has the highest priority and overrides all other inputs. The clock signal `clk` synchronizes state transitions, except for the asynchronous reset.",
  "Timing logic": "This is a sequential circuit with at least two registers to store the walking direction (left or right) and potentially another register to indicate the falling state. The state transitions occur on the positive edge of `clk`. The `walk_left`, `walk_right`, and `aaah` outputs are registered (Moore machine). Non-blocking assignments (`<=`) should be used within the clocked always block to update the state registers. The `areset` signal is asynchronous and positive-edge triggered, meaning it immediately resets the state regardless of the clock."
}
```

The header you have already known is:module top_module (
	input clk,
	input areset,
	input bump_left,
	input bump_right,
	input ground,
	output walk_left,
	output walk_right,
	output aaah
);


Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

