# Messages for Task: review2015_fsmshift

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.

This module is a part of the FSM for controlling the shift register, we want the ability to enable the shift register for exactly 4 clock cycles whenever the proper bit pattern is detected. Whenever the FSM is reset, assert shift_ena for 4 cycles, then 0 forever (until reset). Reset should be active high synchronous.

The header you have already known is:module top_module(
	input clk,
	input reset,
	output shift_ena);


Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

