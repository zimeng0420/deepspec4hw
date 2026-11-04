# Messages for Task: mt2015_eq2

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog, Python and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can reply with the Verilog code after syntax check.
Create a circuit that has two 2-bit inputs A[1:0] and B[1:0], and produces an output z. The value of z should be 1 if A = B, otherwise z should be 0.
```

## User Message

```


Please only reply with the Verilog code, no other words.

Please always begin with `module top_module()`. Create a circuit that has two 2-bit inputs A[1:0] and B[1:0], and produces an output z. The value of z should be 1 if A = B, otherwise z should be 0.module top_module(
	input [1:0] A,
	input [1:0] B,
	output z);

```

