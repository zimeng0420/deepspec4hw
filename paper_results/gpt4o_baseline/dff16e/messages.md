# Messages for Task: dff16e

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.
```

## User Message
```

```
Create 16 D flip-flops. It's sometimes useful to only modify parts of a group of flip-flops. The byte-enable inputs control whether each byte of the 16 registers should be written to on that cycle. byteena[1] controls the upper byte d[15:8], while byteena[0] controls the lower byte d[7:0]. resetn is a synchronous, active-low reset. All DFFs should be triggered by the positive edge of clk.

The header you have already known is:module top_module(
	input clk,
	input resetn,
	input [1:0] byteena,
	input [15:0] d,
	output reg [15:0] q);


Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

