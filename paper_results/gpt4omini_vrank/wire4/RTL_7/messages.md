# Messages for Task: wire4

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog, Python and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can reply with the Verilog code after syntax check.
Create a module with 3 inputs and 4 outputs that behaves like wires that makes these connections: a -> w
// ; b -> x; b -> y; c -> z.
```

## User Message

```


Please only reply with the Verilog code, no other words.

Please always begin with `module top_module()`. Create a module with 3 inputs and 4 outputs that behaves like wires that makes these connections: a -> w
// ; b -> x; b -> y; c -> z.module top_module (
	input a,
	input b,
	input c,
	output w,
	output x,
	output y,
	output z  );

```

