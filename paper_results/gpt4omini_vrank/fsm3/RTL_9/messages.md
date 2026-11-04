# Messages for Task: fsm3

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog, Python and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can reply with the Verilog code after syntax check.
The following is the state transition table for a Moore state machine with one input, one output, and four states. Implement this state machine. Include a positive edge triggered asynchronous reset that resets the FSM to state A.
 
// state | next state in=0, next state in=1 | output
// A | A, B | 0
// B | C, B | 0
// C | A, D | 0
// D | C, B | 1
```

## User Message

```


Please only reply with the Verilog code, no other words.

Please always begin with `module top_module()`. The following is the state transition table for a Moore state machine with one input, one output, and four states. Implement this state machine. Include a positive edge triggered asynchronous reset that resets the FSM to state A.
 
// state | next state in=0, next state in=1 | output
// A | A, B | 0
// B | C, B | 0
// C | A, D | 0
// D | C, B | 1module top_module (
	input clk,
	input in,
	input areset,
	output out
);

```

