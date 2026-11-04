# Messages for Task: lemmings4

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.The game Lemmings involves critters with fairly simple brains. So simple that we are going to model it using a finite state machine. In the Lemmings' 2D world, Lemmings can be in one of two states: walking left (walk_left is 1) or walking right (walk_right is 1). It will switch directions if it hits an obstacle. In particular, if a Lemming is bumped on the left (by receiving a 1 on bump_left), it will walk right. If it's bumped on the right (by receiving a 1 on bump_right), it will walk left. If it's bumped on both sides at the same time, it will still switch directions. 
// In addition to walking left and right and changing direction when bumped, when ground=0, the Lemming will fall and say ""aaah!"". When the ground reappears (ground=1), the Lemming will resume walking in the same direction as before the fall. Being bumped while falling does not affect the walking direction, and being bumped in the same cycle as ground disappears (but not yet falling), or when the ground reappears while still falling, also does not affect the walking direction.
// In addition to walking and falling, Lemmings can sometimes be told to do useful things, like dig (it starts digging when dig=1). A Lemming can dig if it is currently walking on ground (ground=1 and not falling), and will continue digging until it reaches the other side (ground=0). At that point, since there is no ground, it will fall (aaah!), then continue walking in its original direction once it hits ground again. As with falling, being bumped while digging has no effect, and being told to dig when falling or when there is no ground is ignored. (In other words, a walking Lemming can fall, dig, or switch directions. If more than one of these conditions are satisfied, fall has higher precedence than dig, which has higher precedence than switching directions.)
// Although Lemmings can walk, fall, and dig, Lemmings aren't invulnerable. If a Lemming falls for too long then hits the ground, it can splatter. In particular, if a Lemming falls for more than 20 clock cycles then hits the ground, it will splatter and cease walking, falling, or digging (all 4 outputs become 0), forever (Or until the FSM gets reset). There is no upper limit on how far a Lemming can fall before hitting the ground. Lemmings only splatter when hitting the ground; they do not splatter in mid-air.
// Implement a Moore state machine that models this behaviour. areset is positive edge triggered asynchronous reseting the Lemming machine to walk left.The header you have already known is:module top_module (
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

```

## User Message

```


You can use the technical specification as follows:Pure CMB Logic :
```json
{
  "header": "module top_module (input clk, input areset, input bump_left, input bump_right, input ground, input dig, output walk_left, output walk_right, output aaah, output digging);",

  "combinational_logic_function": "The outputs of the combinational logic are derived from the inputs based on the defined behavior of the Lemming. The logic can be organized into several functional blocks: 1) Direction Control Logic, 2) Falling Logic, 3) Digging Logic, and 4) Splatter Logic. The Direction Control Logic determines the walking direction based on bump inputs, while the Falling Logic manages the falling state based on the ground input. The Digging Logic allows for digging when conditions are met, and the Splatter Logic ensures that the Lemming ceases all actions after falling for too long. The signal flow is optimized by ensuring that each block only activates when necessary, minimizing unnecessary transitions. Critical paths are identified between the bump inputs and the direction outputs, ensuring that the logic is balanced to prevent delays. Multiplexing is used to select between walking left, walking right, and falling states, ensuring that only one output is active at any time. The logic is designed to prioritize falling over digging and direction changes, with clear precedence established in the output logic design.",

  "enhanced_combinational_description": "Comprehensive combinational logic specification derived from User: SEQ. The Lemming can be in one of two states: walking left (walk_left = 1) or walking right (walk_right = 1). The direction is controlled by bump_left and bump_right inputs. If bump_left = 1, then walk_right = 1 and walk_left = 0; if bump_right = 1, then walk_left = 1 and walk_right = 0. If both bumps are active, the Lemming will still switch directions. The falling state is activated when ground = 0, setting aaah = 1. When ground = 1, the Lemming resumes walking in the last direction. The digging state is activated when dig = 1, but only if ground = 1 and the Lemming is not falling. The Lemming will dig until it encounters ground = 0, at which point it will fall. The splatter condition is checked by counting the number of cycles the Lemming has been falling; if it exceeds 20 cycles and ground = 1, all outputs are set to 0. The logic is structured to ensure that falling takes precedence over digging, which in turn takes precedence over direction changes. This hierarchy is maintained through careful combinational logic design, ensuring that the Lemming's behavior is accurately modeled."
}
```

 With Timing Logic Summary:
```json
{
  "header": "Module top_module models the behavior of Lemmings in a finite state machine. It has inputs for clock, asynchronous reset, bumps, ground state, and digging command, and outputs for walking left, walking right, falling, and digging.",
  "Interface Behavior": "The clk input is the clock signal that drives the state transitions. The areset input is a positive edge-triggered asynchronous reset that initializes the state to walk left. The bump_left and bump_right inputs are used to change the walking direction based on obstacles. The ground input determines if the Lemming is falling or walking, and the dig input allows the Lemming to dig only when on the ground.",
  "Timing Dependency": "The state transitions occur on the positive edge of clk. The areset signal immediately resets the state to walk left. The timing for bump_left and bump_right inputs is critical as they can change the state during the clock cycle. The ground signal must be stable for at least one clock cycle to ensure proper state transitions. The fall condition is triggered when ground=0, and the splatter condition is checked after 20 clock cycles of falling.",
  "Timing logic": "The FSM consists of several registers to hold the current state and the count of clock cycles falling. There are two main registers: one for the current state (walking left or right) and another for the fall duration counter. The state transitions are implemented using non-blocking assignments in the always block triggered by clk. The outputs walk_left, walk_right, aaah, and digging are derived from the current state and conditions checked in the FSM. The design ensures that fall has the highest precedence, followed by dig, and then direction changes based on bumps."
}
```

Please only reply with the Verilog code, no other words.

Please always begin with `module top_module()`. 
```

