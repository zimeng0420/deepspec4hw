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
  "header": "The top module header definition is:\n\n```verilog\nmodule top_module (\n input [15:0] scancode,\n output reg left,\n output reg down,\n output reg right,\n output reg up\n);\n```\n\nThis module, `top_module`, takes a 16-bit input `scancode` and produces four 1-bit outputs: `left`, `down`, `right`, and `up`. These outputs indicate whether the received `scancode` corresponds to a specific arrow key press on a PS/2 keyboard. The outputs are declared as `reg` because they are assigned values within an `always` block (though this specification focuses solely on the combinational logic aspect, and the `reg` declaration is a consequence of typical Verilog coding style for such logic).",
  "combinational_logic_function": "The combinational logic function maps the 16-bit `scancode` input to the four arrow key outputs. The logic operates as a decoder, where specific `scancode` values activate corresponding output signals. The function can be described as follows:\n\n*   `left` = 1 if `scancode` == 16'he06b, otherwise `left` = 0.\n*   `down` = 1 if `scancode` == 16'he072, otherwise `down` = 0.\n*   `right` = 1 if `scancode` == 16'he074, otherwise `right` = 0.\n*   `up` = 1 if `scancode` == 16'he075, otherwise `up` = 0.\n\nThis can be implemented using a case statement or a series of if-else if statements. The logic organization is straightforward: the input `scancode` is compared against a set of predefined values, and the corresponding output is asserted if a match is found. No operator sharing or resource utilization strategies are explicitly defined at this level of abstraction. The signal flow is direct, from the input `scancode` to the output signals. There is no output multiplexing or selection logic beyond the basic decoding function.",
  "enhanced_combinational_description": "This specification details a combinational logic circuit designed to decode PS/2 keyboard scancodes and identify arrow key presses. The circuit, named `top_module`, receives a 16-bit input `scancode` representing the last two bytes of a PS/2 scancode. Based on the value of `scancode`, the circuit asserts one of four output signals: `left`, `down`, `right`, or `up`, indicating the corresponding arrow key has been pressed. If the `scancode` does not match any of the defined arrow key scancodes, all output signals remain deasserted.\n\nThe specific scancode mappings are as follows:\n\n*   `scancode` = 16'he06b: The `left` output is asserted (set to 1), indicating the left arrow key was pressed. All other outputs (`down`, `right`, `up`) are deasserted (set to 0).\n*   `scancode` = 16'he072: The `down` output is asserted (set to 1), indicating the down arrow key was pressed. All other outputs (`left`, `right`, `up`) are deasserted (set to 0).\n*   `scancode` = 16'he074: The `right` output is asserted (set to 1), indicating the right arrow key was pressed. All other outputs (`left`, `down`, `up`) are deasserted (set to 0).\n*   `scancode` = 16'he075: The `up` output is asserted (set to 1), indicating the up arrow key was pressed. All other outputs (`left`, `down`, `right`) are deasserted (set to 0).\n*   For any other value of `scancode`, all outputs (`left`, `down`, `right`, `up`) are deasserted (set to 0).\n\nThe circuit's functionality can be implemented using a case statement or a series of if-else if statements. The outputs are mutually exclusive; only one output can be asserted at any given time, or none if the input scancode does not match any of the specified arrow key scancodes. The circuit is purely combinational, meaning the outputs are a direct function of the current input `scancode` value. There is no internal state or memory. The outputs are registered, which is a common practice in digital design, but the core logic remains combinational. The registered outputs ensure a clean and stable output signal."
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

