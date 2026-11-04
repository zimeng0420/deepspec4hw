# Messages for Task: 2013_q2bfsm

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.Consider a finite state machine that is used to control some type of motor. The FSM has inputs x and y, which come from the motor, and produces outputs f and g, which control the motor. There is also a clock input called clk and a reset input (synchronous, active low) called resetn. The FSM has to work as follows. As long as the reset input is asserted, the FSM stays in a beginning state, called state A. When the reset signal is de-asserted, then after the next clock edge the FSM has to set the output f to 1 for one clock cycle. Then, the FSM has to monitor the x input. When x has produced the values 1, 0, 1 in three successive clock cycles, then g should be set to 1 on the following clock cycle. While maintaining g = 1 the FSM has to monitor the y input. If y has the value 1 within at most two clock cycles, then the FSM should maintain g = 1 permanently (that is, until reset). But if y does not become 1 within two clock cycles, then the FSM should set g = 0 permanently (until reset).
```

## User Message

```
The header you have already known is:module top_module (
	input clk,
	input resetn,
	input x,
	input y,
	output f,
	output g
);




Please only reply with the Verilog code, no other words.

Please always begin with `module top_module()`. 
```

