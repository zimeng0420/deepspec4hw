# Messages for Task: mux256to1v

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.Create a 4-bit wide, 256-to-1 multiplexer. The 256 4-bit inputs are all packed into a single 1024-bit input vector. sel=0 should select bits in[3:0], sel=1 selects bits in[7:4], sel=2 selects bits in[11:8], etc.

The header you have already known is:module top_module (
	input [1023:0] in,
	input [7:0] sel,
	output [3:0] out
);


Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

