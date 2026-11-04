# Messages for Task: mux256to1

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.
```

## User Message
```

```
Create a 1-bit wide, 256-to-1 multiplexer. The 256 inputs are all packed into a single 256-bit input vector. sel=0 should select in[0], sel=1 selects bits in[1], sel=2 selects bits in[2], etc.

The header you have already known is:module top_module (
	input [255:0] in,
	input [7:0] sel,
	output  out
);


Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

