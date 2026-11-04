# Messages for Task: 2014_q3fsm

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.Consider a finite state machine with inputs s and w. Assume that the FSM begins in a reset state called A, as depicted below. The FSM remains in state A as long as s = 0, and it moves to state B when s = 1. Once in state B the FSM examines the value of the input w in the next three clock cycles. If w = 1 in exactly two of these clock cycles, then the FSM has to set an output z to 1 in the following clock cycle. Otherwise z has to be 0. The FSM continues checking w for the next three clock cycles, and so on. Use as few states as possible. Note that the s input is used only in state A, so you need to consider just the w input. Assume reset is active high synchronous.

The header you have already known is:module top_module (
	input clk,
	input reset,
	input s,
	input w,
	output reg z
);


Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

