# Messages for Task: lemmings4

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.The game Lemmings involves critters with fairly simple brains. So simple that we are going to model it using a finite state machine. In the Lemmings' 2D world, Lemmings can be in one of two states: walking left (walk_left is 1) or walking right (walk_right is 1). It will switch directions if it hits an obstacle. In particular, if a Lemming is bumped on the left (by receiving a 1 on bump_left), it will walk right. If it's bumped on the right (by receiving a 1 on bump_right), it will walk left. If it's bumped on both sides at the same time, it will still switch directions. 
// In addition to walking left and right and changing direction when bumped, when ground=0, the Lemming will fall and say ""aaah!"". When the ground reappears (ground=1), the Lemming will resume walking in the same direction as before the fall. Being bumped while falling does not affect the walking direction, and being bumped in the same cycle as ground disappears (but not yet falling), or when the ground reappears while still falling, also does not affect the walking direction.
// In addition to walking and falling, Lemmings can sometimes be told to do useful things, like dig (it starts digging when dig=1). A Lemming can dig if it is currently walking on ground (ground=1 and not falling), and will continue digging until it reaches the other side (ground=0). At that point, since there is no ground, it will fall (aaah!), then continue walking in its original direction once it hits ground again. As with falling, being bumped while digging has no effect, and being told to dig when falling or when there is no ground is ignored. (In other words, a walking Lemming can fall, dig, or switch directions. If more than one of these conditions are satisfied, fall has higher precedence than dig, which has higher precedence than switching directions.)
// Although Lemmings can walk, fall, and dig, Lemmings aren't invulnerable. If a Lemming falls for too long then hits the ground, it can splatter. In particular, if a Lemming falls for more than 20 clock cycles then hits the ground, it will splatter and cease walking, falling, or digging (all 4 outputs become 0), forever (Or until the FSM gets reset). There is no upper limit on how far a Lemming can fall before hitting the ground. Lemmings only splatter when hitting the ground; they do not splatter in mid-air.
// Implement a Moore state machine that models this behaviour. areset is positive edge triggered asynchronous reseting the Lemming machine to walk left.

The compressed specification is as follows: Pure CMB Logic :
```json
{
  "header": "module top_module (\n\tinput clk,\n\tinput areset,\n\tinput bump_left,\n\tinput bump_right,\n\tinput ground,\n\tinput dig,\n\toutput walk_left,\n\toutput walk_right,\n\toutput aaah,\n\toutput digging\n);",
  "combinational_logic_function": "The combinational logic determines the outputs (walk_left, walk_right, aaah, digging) based on the current inputs (bump_left, bump_right, ground, dig) and the current state of the Lemming. The precedence of actions is fall > dig > direction change. The 'aaah' output is asserted when the Lemming is falling (ground=0). The 'digging' output is asserted when the Lemming is digging (dig=1 and ground=1). The 'walk_left' and 'walk_right' outputs indicate the Lemming's walking direction, which changes based on 'bump_left' and 'bump_right' inputs. The 'areset' signal asynchronously resets the Lemming to the walking left state. The combinational logic must also account for the 'splatter' condition, where all outputs are deasserted. The combinational logic is structured to prioritize the 'fall' condition, followed by 'dig', and then direction changes. The 'aaah' output is directly derived from the 'ground' input. The 'digging' output is derived from the 'dig' and 'ground' inputs. The 'walk_left' and 'walk_right' outputs are derived from the current state and the 'bump_left' and 'bump_right' inputs. The 'splatter' condition overrides all other outputs.",
  "enhanced_combinational_description": "The combinational logic for the Lemmings FSM determines the outputs based on the current inputs and the current state. The outputs are 'walk_left', 'walk_right', 'aaah', and 'digging'. The inputs are 'bump_left', 'bump_right', 'ground', and 'dig'.\n\n1.  **Walking Direction Logic:**\n    *   If 'bump_left' is asserted, the Lemming changes direction to walk right. If 'bump_right' is asserted, the Lemming changes direction to walk left. If both 'bump_left' and 'bump_right' are asserted, the Lemming still changes direction. The current walking direction is stored in the state. The outputs 'walk_left' and 'walk_right' are mutually exclusive and are determined by the current state.\n\n2.  **Falling Logic:**\n    *   If 'ground' is deasserted (ground=0), the Lemming is falling. The 'aaah' output is asserted when the Lemming is falling. The falling condition has the highest precedence.\n\n3.  **Digging Logic:**\n    *   If 'dig' is asserted and 'ground' is asserted, the Lemming starts digging. The 'digging' output is asserted when the Lemming is digging. The digging condition has lower precedence than falling.\n\n4.  **Precedence Logic:**\n    *   The precedence of actions is fall > dig > direction change. This means that if the Lemming is falling, the 'aaah' output is asserted regardless of the 'dig' and 'bump' inputs. If the Lemming is not falling but 'dig' is asserted and 'ground' is asserted, the 'digging' output is asserted regardless of the 'bump' inputs. If the Lemming is neither falling nor digging, the 'bump' inputs determine the walking direction.\n\n5.  **Output Equations (Illustrative):**\n    *   `aaah = !ground;`\n    *   `digging = dig & ground & !falling;`\n    *   `walk_left = (current_state == WALKING_LEFT) & !falling & !digging & !splattered;`\n    *   `walk_right = (current_state == WALKING_RIGHT) & !falling & !digging & !splattered;`\n\n6. **Splattering Logic:**
    *   The 'splattered' output is asserted when the Lemming has fallen for more than 20 clock cycles and then hits the ground. When 'splattered' is asserted, all other outputs are deasserted.
    *   `walk_left = 0;`
    *   `walk_right = 0;`
    *   `aaah = 0;`
    *   `digging = 0;`

The combinational logic is designed to implement these rules and generate the appropriate outputs based on the current inputs and the current state. The 'areset' signal asynchronously resets the Lemming to the walking left state, overriding all other inputs."
}
```

 With Timing Logic Summary:
```json
{
  "header": "The module `top_module` models the behavior of a Lemming using a Moore state machine. It has inputs for clock (`clk`), asynchronous reset (`areset`), bump sensors (`bump_left`, `bump_right`), ground detection (`ground`), and a dig command (`dig`). It has outputs indicating the Lemming's actions: walking direction (`walk_left`, `walk_right`), falling (`aaah`), and digging (`digging`). The Lemming can walk left or right, fall, dig, or splatter. Resetting the module puts the Lemming in the walking left state.",
  "Interface Behavior": "The `areset` input asynchronously resets the state machine to the walking left state. The `clk` input clocks all state transitions. The `bump_left`, `bump_right`, `ground`, and `dig` inputs affect the state transitions on the rising edge of `clk`. The outputs `walk_left`, `walk_right`, `aaah`, and `digging` are synchronous with the `clk` and reflect the current state of the Lemming.",
  "Timing Dependency": "The falling duration is tracked using a counter. If the `ground` input is 0 for more than 20 clock cycles, and then `ground` becomes 1, the Lemming splatters. The critical path involves the falling duration counter, the `ground` input, and the logic that determines whether to enter the splatter state. The exact delay of the combinational logic is unknown, but the state transitions are synchronized to the rising edge of the `clk` input.",
  "Timing logic": "The state machine likely uses `reg` declarations for internal state variables to track the Lemming's current activity (walking direction, falling, digging, splattered). Non-blocking assignments (`<=`) are used within the `always @(posedge clk)` block to update the state variables on each clock cycle. The `areset` input asynchronously resets the state, overriding the clocked behavior. The falling duration counter is incremented when `ground` is 0 and reset when `ground` is 1 or when `areset` is asserted. The outputs are assigned based on the current state variables."
}
```

The header you have already known is:module top_module (
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


Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

