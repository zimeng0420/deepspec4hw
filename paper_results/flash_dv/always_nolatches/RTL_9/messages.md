# Messages for Task: always_nolatches

## System Message

```
You are the strongest AI in the world. You already have the knowledge of Verilog and hardware designing. Generate Verilog code for the given task. I will tip you $200 if you can fulfill the tasks I give you.

Suppose you're building a circuit to process scancodes from a PS/2 keyboard for a game. Given the last two bytes of scancodes received, you need to indicate whether one of the arrow keys on the keyboard have been pressed. This involves a fairly simple mapping, which can be implemented as a case statement (or if-elseif) with four cases.
// Scancode[15:0] | Arrow key
// 16'he06b | left arrow
// 16'he072 | down arrow
// 16'he074 | right arrow
// 16'he075 | up arrow
// Anything else | none
// Your circuit has one 16-bit input, and four outputs. Build this circuit that recognizes these four scancodes and asserts the correct output.



The specification is as follows:
# Agent Response for Task: always_nolatches

```json
{
  "header": "The top module header definition is:\n\n```verilog\nmodule top_module (\n    input [15:0] scancode,\n    output reg left,\n    output reg down,\n    output reg right,\n    output reg up\n);\n```\n\nThis module, `top_module`, takes a 16-bit input `scancode` and produces four 1-bit outputs: `left`, `down`, `right`, and `up`. The `scancode` input represents the scan code received from a PS/2 keyboard. The outputs indicate whether a specific arrow key (left, down, right, or up) has been pressed. The outputs are declared as `reg` because they are assigned values within an `always` block.",
  "combinational_logic_function": "The combinational logic function maps the 16-bit `scancode` input to the four 1-bit outputs (`left`, `down`, `right`, `up`). The mapping is defined as follows:\n\n*   If `scancode` is equal to `16'he06b`, then `left` is asserted (set to 1), and `down`, `right`, and `up` are deasserted (set to 0).\n*   If `scancode` is equal to `16'he072`, then `down` is asserted (set to 1), and `left`, `right`, and `up` are deasserted (set to 0).\n*   If `scancode` is equal to `16'he074`, then `right` is asserted (set to 1), and `left`, `down`, and `up` are deasserted (set to 0).\n*   If `scancode` is equal to `16'he075`, then `up` is asserted (set to 1), and `left`, `down`, and `right` are deasserted (set to 0).\n*   If `scancode` is any other value, then `left`, `down`, `right`, and `up` are all deasserted (set to 0).\n\nThis function can be implemented using a case statement, which provides a direct and efficient way to decode the input and set the corresponding output. The logic organization consists of a single decoding block that examines the `scancode` and activates the appropriate output. The signal flow is straightforward: the `scancode` is the input, and the `left`, `down`, `right`, and `up` signals are the outputs. There is no operator sharing or resource utilization strategy needed due to the simplicity of the logic. Logic level balancing and delay equalization techniques are not applicable in this simple design. The output multiplexing and selection logic is implicitly handled by the case statement, which selects one of the four possible output configurations based on the input `scancode`.",
  "enhanced_combinational_description": "The combinational logic circuit decodes a 16-bit `scancode` input from a PS/2 keyboard and asserts the corresponding arrow key output. The circuit implements the following truth table:\n\n| scancode    | left | down | right | up |\n|-------------|------|------|-------|----|\n| 16'he06b   | 1    | 0    | 0     | 0  |\n| 16'he072   | 0    | 1    | 0     | 0  |\n| 16'he074   | 0    | 0    | 1     | 0  |\n| 16'he075   | 0    | 0    | 0     | 1  |\n| default     | 0    | 0    | 0     | 0  |\n\nThe circuit is implemented using a case statement that checks the value of the `scancode` input. The case statement has five cases:\n\n1.  **Case 16'he06b:** If the `scancode` is equal to `16'he06b`, the `left` output is set to 1, and the `down`, `right`, and `up` outputs are set to 0. This corresponds to the left arrow key.\n2.  **Case 16'he072:** If the `scancode` is equal to `16'he072`, the `down` output is set to 1, and the `left`, `right`, and `up` outputs are set to 0. This corresponds to the down arrow key.\n3.  **Case 16'he074:** If the `scancode` is equal to `16'he074`, the `right` output is set to 1, and the `left`, `down`, and `up` outputs are set to 0. This corresponds to the right arrow key.\n4.  **Case 16'he075:** If the `scancode` is equal to `16'he075`, the `up` output is set to 1, and the `left`, `down`, and `right` outputs are set to 0. This corresponds to the up arrow key.\n5.  **Default Case:** If the `scancode` does not match any of the above cases, all outputs (`left`, `down`, `right`, and `up`) are set to 0. This ensures that no arrow key is indicated as pressed if an unknown scancode is received.\n\nThe `always @(*)` block ensures that the outputs are updated whenever the input `scancode` changes. The outputs are declared as `reg` because they are assigned values within the `always` block. The use of a `default` case is crucial to prevent unintended latch generation during synthesis. The case statement provides a clear and efficient way to decode the input and set the corresponding outputs, making it suitable for hardware implementation."
}
```

Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

