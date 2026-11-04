# Messages for Task: conditional

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog, Python and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can reply with the Verilog code after syntax check.
Given four unsigned numbers, find the minimum. Unsigned numbers can be compared with standard comparison operators (a < b). 
```

## User Message

```


Please only reply with the Verilog code, no other words.

Please always begin with `module top_module()`. Given four unsigned numbers, find the minimum. Unsigned numbers can be compared with standard comparison operators (a < b). module top_module (
	input [7:0] a,
	input [7:0] b,
	input [7:0] c,
	input [7:0] d,
	output reg [7:0] min
);

```

