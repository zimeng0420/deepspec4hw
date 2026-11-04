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
  "header": "module top_module (\n\tinput [15:0] scancode,\n\toutput reg left,\n\toutput reg down,\n\toutput reg right,\n\toutput reg up\n);",
  "combinational_logic_function": "The circuit decodes a 16-bit input 'scancode' to activate one of four output signals: 'left', 'down', 'right', and 'up'. The decoding is based on a direct comparison of the 'scancode' input with four specific hexadecimal values. If 'scancode' equals 16'he06b, the 'left' output is asserted (set to 1). If 'scancode' equals 16'he072, the 'down' output is asserted. If 'scancode' equals 16'he074, the 'right' output is asserted. If 'scancode' equals 16'he075, the 'up' output is asserted. If 'scancode' does not match any of these four values, all four outputs ('left', 'down', 'right', 'up') are deasserted (set to 0). The logic can be implemented using a case statement or a series of if-elseif-else statements. The outputs are mutually exclusive; only one output can be asserted at any given time, or none if the input scancode is not recognized.",
  "enhanced_combinational_description": "This combinational logic circuit is designed to decode PS/2 keyboard scancodes for arrow keys. The circuit receives a 16-bit input 'scancode' and produces four 1-bit outputs: 'left', 'down', 'right', and 'up'. The function of the circuit is to assert the appropriate output signal based on the value of the 'scancode' input. The following table defines the mapping between the 'scancode' input and the output signals:\n\n| scancode (hex) | left | down | right | up |\n|------------------|------|------|-------|----|\n| e06b             | 1    | 0    | 0     | 0  |\n| e072             | 0    | 1    | 0     | 0  |\n| e074             | 0    | 0    | 1     | 0  |\n| e075             | 0    | 0    | 0     | 1  |\n| Other            | 0    | 0    | 0     | 0  |\n\nThe circuit operates as follows: The 'scancode' input is compared against the four predefined scancodes (e06b, e072, e074, e075). If a match is found, the corresponding output signal is asserted (set to 1). If no match is found, all output signals are deasserted (set to 0). The outputs are mutually exclusive, meaning that only one output can be active at any given time. The circuit can be implemented using a case statement or a series of if-elseif-else statements. The 'reg' keyword in the output declaration does not affect the combinational nature of the circuit; it is simply a Verilog syntax requirement for assigning values to outputs within an always block (if one were used, which is not required for a purely combinational implementation). The circuit's functionality is purely combinational, meaning that the outputs are solely dependent on the current input values. There is no internal state or memory within the circuit."
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

