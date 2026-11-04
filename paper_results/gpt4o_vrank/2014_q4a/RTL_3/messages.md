# Messages for Task: 2014_q4a

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.Consider an n-bit shift register circuit. Inputs E are for enabling shift, R for value to load, L is asserted when it should load, and w is the input to the first stage of the shift register. Write a Verilog module named top_module for one stage of this circuit, including both the flip-flop and multiplexers.
```

## User Message

```
The header you have already known is:module top_module (
	input clk,
	input w,
	input R,
	input E,
	input L,
	output reg Q
);




Please only reply with the Verilog code, no other words.

Please always begin with `module top_module()`. 
```

