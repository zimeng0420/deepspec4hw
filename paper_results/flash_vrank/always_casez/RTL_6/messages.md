# Messages for Task: always_casez

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.

Build a priority encoder for 8-bit inputs. Given an 8-bit vector, the output should report the first (least significant) bit in the vector that is 1. Report zero if the input vector has no bits that are high. For example, the input 8'b10010000 should output 3'd4, because bit[4] is first bit that is high.

The header you have already known is:module top_module (
	input [7:0] in,
	output reg [2:0] pos
);


Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

