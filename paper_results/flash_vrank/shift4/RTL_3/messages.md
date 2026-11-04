# Messages for Task: shift4

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.

Build a 4-bit shift register (right shift), with asynchronous positive edge triggered areset, synchronous active high signals load, and enable. 
// (1) areset: Resets shift register to zero. 
// (2) load: Loads shift register with data[3:0] instead of shifting. 
// (3) ena: Shift right (q[3] becomes zero, q[0] is shifted out and disappears). 
// (4) q: The contents of the shift register. If both the load and ena inputs are asserted (1), the load input has higher priority. 


The header you have already known is:module top_module(
	input clk,
	input areset,
	input load,
	input ena,
	input [3:0] data,
	output reg [3:0] q);


Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

