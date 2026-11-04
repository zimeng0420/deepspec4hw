# Messages for Task: bugs_case

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.

This combinational circuit is supposed to recognize 8-bit keyboard scancodes for keys 0 through 9. It should indicate whether one of the 10 cases were recognized (valid), and if so, which key was detected. If the 8-bit input is 8'h45, 8'h16, 8'h1e, 8'h26, 8'h25, 8'h2e, 8'h36, 8'h3d, 8'h3e, or 8'h46, the 4-bit output will be set to 0, 1, 2, 3, 4, 5, 6, 7, 8, or 9 respectively, the 1-bit valid would be set to 1. If the input does not match any of the cases, both output signals would be set to 0.

The header you have already known is:module top_module (
	input [7:0] code,
	output reg [3:0] out,
	output reg valid
);


Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

