# Messages for Task: review2015_fsmseq

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog, Python and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can reply with the Verilog code after syntax check.
Build a finite-state machine that searches for the sequence 1101 in an input bit stream. When the sequence is found, it should set start_shifting to 1, forever, until reset. Reset is active high synchronous.
```

## User Message

```


Please only reply with the Verilog code, no other words.

Please always begin with `module top_module()`. Build a finite-state machine that searches for the sequence 1101 in an input bit stream. When the sequence is found, it should set start_shifting to 1, forever, until reset. Reset is active high synchronous.module top_module(
	input clk,
	input reset,
	input data,
	output start_shifting);

```

