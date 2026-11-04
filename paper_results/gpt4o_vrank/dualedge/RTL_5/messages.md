# Messages for Task: dualedge

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.A dual-edge triggered flip-flop is triggered on both edges of the clock. However, FPGAs don't have dual-edge triggered flip-flops, and always @(posedge clk or negedge clk) is not accepted as a legal sensitivity list. Build a circuit that functionally behaves like a dual-edge triggered flip-flop.
```

## User Message

```
The header you have already known is:module top_module(
	input clk,
	input d,
	output reg q);




Please only reply with the Verilog code, no other words.

Please always begin with `module top_module()`. 
```

