# Messages for Task: 2014_q3c

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.

Given the state-assigned table shown below, implement the logic functions Y[0] and z.
// Present state y[2:0] | Next state Y[2:0] x=0, Next state Y[2:0] x=1 | Output z
// 000 | 000, 001 | 0
// 001 | 001, 100 | 0
// 010 | 010, 001 | 0
// 011 | 001, 010 | 1
// 100 | 011, 100 | 1


The header you have already known is:module top_module (
	input clk,
	input x,
	input [2:0] y,
	output reg Y0,
	output reg z
);


Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

