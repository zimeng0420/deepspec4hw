# Messages for Task: ece241_2014_q1c

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog, Python and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can reply with the Verilog code after syntax check.
Assume that you have two 8-bit 2's complement numbers, a[7:0] and b[7:0]. These numbers are added to produce s[7:0]. Also compute whether a (signed) overflow has occurred.
```

## User Message

```


Please only reply with the Verilog code, no other words.

Please always begin with `module top_module()`. Assume that you have two 8-bit 2's complement numbers, a[7:0] and b[7:0]. These numbers are added to produce s[7:0]. Also compute whether a (signed) overflow has occurred.module top_module (
	input [7:0] a,
	input [7:0] b,
	output [7:0] s,
	output overflow
);

```

