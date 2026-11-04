# Messages for Task: lemmings1

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.
```

## User Message
```

```
The game Lemmings involves critters with fairly simple brains. So simple that we are going to model it using a finite state machine. In the Lemmings' 2D world, Lemmings can be in one of two states: walking left (walk_left is 1) or walking right (walk_right is 1). It will switch directions if it hits an obstacle. In particular, if a Lemming is bumped on the left (by receiving a 1 on bump_left), it will walk right. If it's bumped on the right (by receiving a 1 on bump_right), it will walk left. If it's bumped on both sides at the same time, it will still switch directions. Implement a Moore state machine with two states, two inputs, and one output (internal to the module) that models this behaviour. areset is positive edge triggered asynchronous reseting the Lemming machine to walk left.

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

