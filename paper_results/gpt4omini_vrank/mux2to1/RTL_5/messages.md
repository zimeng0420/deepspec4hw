# Messages for Task: mux2to1

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog, Python and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can reply with the Verilog code after syntax check.
Create a one-bit wide, 2-to-1 multiplexer. When sel=0, choose a. When sel=1, choose b.
```

## User Message

```


Please only reply with the Verilog code, no other words.

Please always begin with `module top_module()`. Create a one-bit wide, 2-to-1 multiplexer. When sel=0, choose a. When sel=1, choose b.module top_module (
	input a,
	input b,
	input sel,
	output out
);

```

