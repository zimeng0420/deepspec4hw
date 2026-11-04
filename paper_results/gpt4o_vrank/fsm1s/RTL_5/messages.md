# Messages for Task: fsm1s

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.This is a Moore state machine with two states, one input, and one output. Implement this state machine in Verilog. The reset state is B and reset is active-high synchronous.

// B (out=1) --in=0--> A
// B (out=1) --in=1--> B
// A (out=0) --in=0--> B
// A (out=0) --in=1--> A
```

## User Message

```
The header you have already known is:module top_module (
	input clk,
	input in,
	input reset,
	output out
);




Please only reply with the Verilog code, no other words.

Please always begin with `module top_module()`. 
```

