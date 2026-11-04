# Messages for Task: dff8ar

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog, Python and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can reply with the Verilog code after syntax check.
Create 8 D flip-flops with active high asynchronous reset. The output should be reset to 0. All DFFs should be triggered by the positive edge of clk.
```

## User Message

```


Please only reply with the Verilog code, no other words.

Please always begin with `module top_module()`. Create 8 D flip-flops with active high asynchronous reset. The output should be reset to 0. All DFFs should be triggered by the positive edge of clk.module top_module(
	input clk,
	input [7:0] d,
	input areset,
	output reg [7:0] q);

```

