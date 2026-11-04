# Messages for Task: countbcd

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate only a technical specification for the given task. I will tip you $200 if you can fulfill the tasks I give you.Build a 4-digit BCD (binary-coded decimal) counter. Each decimal digit is encoded using 4 bits: q[3:0] is the ones digit, q[7:4] is the tens digit, etc. For digits [3:1], also output an enable signal indicating when each of the upper three digits should be incremented. Include a synchronous active-high reset.


```

## User Message

```
The header you have already known is:module top_module(
	input clk,
	input reset,
	output [3:1] ena,
	output reg [15:0] q);

```

