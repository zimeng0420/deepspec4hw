# Messages for Task: ece241_2014_q5a

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate only a technical specification for the given task. I will tip you $200 if you can fulfill the tasks I give you.You are to design a one-input one-output serial 2's complementer Moore state machine. The input (x) is a series of bits (one per clock cycle) beginning with the least-significant bit of the number, and the output (Z) is the 2's complement of the input. The machine will accept input numbers of arbitrary length. The circuit requires a positive edge triggered asynchronous reset. The conversion begins when Reset is released and stops when Reset is asserted.


```

## User Message

```
The header you have already known is:module top_module (
	input clk,
	input areset,
	input x,
	output z
);

```

