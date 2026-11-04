# Messages for Task: edgecapture

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog, Python and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can reply with the Verilog code after syntax check.
For each bit in a 32-bit vector, capture when the input signal changes from 1 in one clock cycle to 0 the next. "Capture" means that the output will remain 1 until the register is reset (active high synchronous reset).
```

## User Message

```


Please only reply with the Verilog code, no other words.

Please always begin with `module top_module()`. For each bit in a 32-bit vector, capture when the input signal changes from 1 in one clock cycle to 0 the next. "Capture" means that the output will remain 1 until the register is reset (active high synchronous reset).module top_module(
	input clk,
	input reset,
	input [31:0] in,
	output reg [31:0] out);

```

