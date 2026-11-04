# Messages for Task: fsm2

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.This is a Moore state machine with two states, two inputs, and one output. Implement this state machine in Verilog. Reset is an active-high asynchronous reset to state OFF.

// OFF (out=0) --j=0--> OFF
// OFF (out=0) --j=1--> ON
// ON (out=1) --k=0--> ON
// ON (out=1) --k=1--> OFF
```

## User Message

```
The header you have already known is:module top_module (
	input clk,
	input j,
	input k,
	input areset,
	output out
);




Please only reply with the Verilog code, no other words.

Please always begin with `module top_module()`. 
```

