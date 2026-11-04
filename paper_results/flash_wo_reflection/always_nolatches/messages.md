# Messages for Task: always_nolatches

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.Suppose you're building a circuit to process scancodes from a PS/2 keyboard for a game. Given the last two bytes of scancodes received, you need to indicate whether one of the arrow keys on the keyboard have been pressed. This involves a fairly simple mapping, which can be implemented as a case statement (or if-elseif) with four cases.
// Scancode[15:0] | Arrow key
// 16'he06b | left arrow
// 16'he072 | down arrow
// 16'he074 | right arrow
// 16'he075 | up arrow
// Anything else | none
// Your circuit has one 16-bit input, and four outputs. Build this circuit that recognizes these four scancodes and asserts the correct output.



The compressed specification is as follows: ```json
{
  "header": "The top module header definition is:\n\n```verilog\nmodule top_module (\n    input [15:0] scancode,\n    output reg left,\n    output reg down,\n    output reg right,\n    output reg up\n);\n```\n\nThis defines a module named `top_module` with a 16-bit input `scancode` and four 1-bit output registers: `left`, `down`, `right`, and `up`. The `scancode` input represents the PS/2 keyboard scancode, and the outputs indicate whether the corresponding arrow key is pressed.",
  "combinational_logic_function": "The combinational logic function maps the 16-bit `scancode` input to the four output signals based on the following Boolean expressions:\n\n*   `left = (scancode == 16'he06b)`\n*   `down = (scancode == 16'he072)`\n*   `right = (scancode == 16'he074)`\n*   `up = (scancode == 16'he075)`\n\nEach output is asserted (set to 1) if the `scancode` input matches the specific hexadecimal value associated with that arrow key. Otherwise, the output is deasserted (set to 0). The logic organization consists of four independent comparators, each comparing the `scancode` input with a specific constant. The output of each comparator directly drives the corresponding output register. There is no operator sharing or output multiplexing. The signal flow is straightforward: the `scancode` input is broadcast to all four comparators, and the comparator outputs directly drive the output registers.",
  "enhanced_combinational_description": "This combinational logic circuit decodes PS/2 keyboard scancodes to detect arrow key presses. The circuit receives a 16-bit input, `scancode`, representing the last two bytes of the received scancode. The circuit has four 1-bit outputs: `left`, `down`, `right`, and `up`. Each output corresponds to a specific arrow key. The circuit's function is to assert the corresponding output if the `scancode` matches the scancode for that arrow key. The specific scancode mappings are as follows:\n\n*   If `scancode` is equal to `16'he06b`, then `left` is asserted (set to 1). Otherwise, `left` is deasserted (set to 0).\n*   If `scancode` is equal to `16'he072`, then `down` is asserted (set to 1). Otherwise, `down` is deasserted (set to 0).\n*   If `scancode` is equal to `16'he074`, then `right` is asserted (set to 1). Otherwise, `right` is deasserted (set to 0).\n*   If `scancode` is equal to `16'he075`, then `up` is asserted (set to 1). Otherwise, `up` is deasserted (set to 0).\n\nIf the `scancode` does not match any of the specified arrow key scancodes, all outputs (`left`, `down`, `right`, and `up`) are deasserted (set to 0). The circuit effectively implements a lookup table where the `scancode` is the key, and the outputs are the values. The implementation consists of four parallel comparators, each checking for a specific scancode. The outputs of the comparators directly drive the output registers. The circuit is purely combinational, meaning that the outputs are a direct function of the current input. There is no internal state or memory."
}
```

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

