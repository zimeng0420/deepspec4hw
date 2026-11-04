# Messages for Task: countslow

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.

Build a decade counter that counts from 0 through 9, inclusive, with a period of 10. The reset input is active high synchronous, and should reset the counter to 0. We want to be able to pause the counter rather than always incrementing every clock cycle, so the "slowena" input if high indicates when the counter should increment. 

The header you have already known is:module top_module(
	input clk,
	input slowena,
	input reset,
	output reg [3:0] q);


Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

