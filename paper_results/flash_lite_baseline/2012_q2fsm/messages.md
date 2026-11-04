# Messages for Task: 2012_q2fsm

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.Consider the state machine shown below:

// A (0) --1--> B
// A (0) --0--> A
// B (0) --1--> C
// B (0) --0--> D
// C (0) --1--> E
// C (0) --0--> D
// D (0) --1--> F
// D (0) --0--> A
// E (1) --1--> E
// E (1) --0--> D
// F (1) --1--> C
// F (1) --0--> D

// Reset resets into state A and is synchronous active-high. 

// Write complete Verilog code that represents this FSM. Use separate **always** blocks for the state table and the state flip-flops. Describe the FSM output, which is called _z_, using either continuous assignment statement(s) or an **always** block (at your discretion). Assign any state codes that you wish to use.

The header you have already known is:module top_module (
	input clk,
	input reset,
	input w,
	output z
);


Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

