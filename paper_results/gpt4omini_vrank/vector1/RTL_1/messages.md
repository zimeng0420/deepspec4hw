# Messages for Task: vector1

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog, Python and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can reply with the Verilog code after syntax check.
Build a combinational circuit that splits an input half-word (16 bits, [15:0] ) into lower [7:0] and upper [15:8] bytes.
```

## User Message

```


Please only reply with the Verilog code, no other words.

Please always begin with `module top_module()`. Build a combinational circuit that splits an input half-word (16 bits, [15:0] ) into lower [7:0] and upper [15:8] bytes.module top_module (
	input [15:0] in,
	output [7:0] out_hi,
	output [7:0] out_lo
);

```

