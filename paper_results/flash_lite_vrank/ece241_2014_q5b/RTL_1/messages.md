# Messages for Task: ece241_2014_q5b

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.

The following diagram is a Mealy machine implementation of the 2's complementer. Implement in Verilog using one-hot encoding. Resets into state A and reset is asynchronous active-high.

// A --x=0 (z=0)--> A
// A --x=1 (z=1)--> B
// B --x=0 (z=1)--> B
// B --x=1 (z=0)--> B

The header you have already known is:module top_module (
	input clk,
	input areset,
	input x,
	output z
);


Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

