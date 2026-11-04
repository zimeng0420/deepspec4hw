# Messages for Task: fsm1

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog, Python and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can reply with the Verilog code after syntax check.
Consider the follow Moore machine with the diagram described below:

// B (1) --0--> A
// B (1) --1--> B
// A (0) --0--> B
// A (0) --1--> A

// Write Verilog implementing this state machine. It should asynchronously reset into state B if reset if high.
```

## User Message

```


Please only reply with the Verilog code, no other words.

Please always begin with `module top_module()`. Consider the follow Moore machine with the diagram described below:

// B (1) --0--> A
// B (1) --1--> B
// A (0) --0--> B
// A (0) --1--> A

// Write Verilog implementing this state machine. It should asynchronously reset into state B if reset if high.module top_module (
	input clk,
	input in,
	input areset,
	output out
);

```

