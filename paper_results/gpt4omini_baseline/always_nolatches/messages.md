# Messages for Task: always_nolatches

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.
```

## User Message
```

```
Suppose you're building a circuit to process scancodes from a PS/2 keyboard for a game. Given the last two bytes of scancodes received, you need to indicate whether one of the arrow keys on the keyboard have been pressed. This involves a fairly simple mapping, which can be implemented as a case statement (or if-elseif) with four cases.
// Scancode[15:0] | Arrow key
// 16'he06b | left arrow
// 16'he072 | down arrow
// 16'he074 | right arrow
// 16'he075 | up arrow
// Anything else | none
// Your circuit has one 16-bit input, and four outputs. Build this circuit that recognizes these four scancodes and asserts the correct output.



The header you have already known is:module top_module (
	input [15:0] scancode,
	output reg left,
	output reg down,
	output reg right,
	output reg up
);


Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

