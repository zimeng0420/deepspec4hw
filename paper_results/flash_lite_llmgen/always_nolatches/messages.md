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



The header you have already known is:module top_module (
	input [15:0] scancode,
	output reg left,
	output reg down,
	output reg right,
	output reg up
);


You can use the technical specification as follows:Okay, I understand the task. I will provide a detailed technical specification for a Verilog module that decodes PS/2 keyboard scancodes to identify arrow key presses. I will also include a complete Verilog implementation.

**Technical Specification: PS/2 Arrow Key Decoder**

**1.  Module Name:** `ps2_arrow_key_decoder`

**2.  Purpose:** This module decodes a 16-bit PS/2 scancode input and asserts the corresponding output signals to indicate which arrow key (if any) has been pressed.

**3.  Inputs:**

*   `scancode [15:0]`: A 16-bit input representing the received PS/2 scancode.

**4.  Outputs:**

*   `left`: A single-bit output.  Asserted (logic 1) when the left arrow key is pressed. Deasserted (logic 0) otherwise.
*   `down`: A single-bit output. Asserted (logic 1) when the down arrow key is pressed. Deasserted (logic 0) otherwise.
*   `right`: A single-bit output. Asserted (logic 1) when the right arrow key is pressed. Deasserted (logic 0) otherwise.
*   `up`: A single-bit output. Asserted (logic 1) when the up arrow key is pressed. Deasserted (logic 0) otherwise.

**5.  Functional Description:**

The module operates as follows:

*   The `scancode` input is compared against the predefined scancode values for each arrow key.
*   A `case` statement (or equivalent `if-elseif` structure) is used to perform the comparison.
*   If the `scancode` matches the value for a specific arrow key, the corresponding output signal is asserted (set to logic 1).
*   If the `scancode` does not match any of the arrow key scancodes, all output signals are deasserted (set to logic 0).

**6.  Scancode Mapping:**

The module implements the following scancode-to-arrow key mapping:

| Scancode      | Arrow Key |
| ------------- | --------- |
| `16'he06b`    | Left      |
| `16'he072`    | Down      |
| `16'he074`    | Right     |
| `16'he075`    | Up        |
| *Anything else* | None      |

**7.  Implementation Details:**

*   The module will be implemented in Verilog.
*   The outputs will be declared as `reg` to allow them to be assigned within the `always` block or `case` statement.
*   The design will be synthesizable.

**8.  Verilog Code (Implementation):**

```verilog
module top_module (
	input [15:0] scancode,
	output reg left,
	output reg down,
	output reg right,
	output reg up
);

	always @(*) begin
		case (scancode)
			16'he06b: begin // Left arrow
				left = 1'b1;
				down = 1'b0;
				right = 1'b0;
				up = 1'b0;
			end
			16'he072: begin // Down arrow
				left = 1'b0;
				down = 1'b1;
				right = 1'b0;
				up = 1'b0;
			end
			16'he074: begin // Right arrow
				left = 1'b0;
				down = 1'b0;
				right = 1'b1;
				up = 1'b0;
			end
			16'he075: begin // Up arrow
				left = 1'b0;
				down = 1'b0;
				right = 1'b0;
				up = 1'b1;
			end
			default: begin // None of the arrow keys
				left = 1'b0;
				down = 1'b0;
				right = 1'b0;
				up = 1'b0;
			end
		endcase
	end

endmodule
```

**9.  Testing/Verification:**

*   A testbench should be created to verify the functionality of the module.
*   The testbench should apply various `scancode` inputs, including the arrow key scancodes and other values, and check that the outputs are asserted and deasserted correctly.
*   Test cases should cover all possible arrow key presses and the "no key pressed" scenario.

**10.  Optimization (Optional):**

*   For this simple design, optimization is not critical. However, the `case` statement is already an efficient way to implement the logic.

**Explanation of the Code:**

*   **`module top_module (...)`**:  Defines the module named `top_module` and declares its inputs and outputs.  This is the header you provided.
*   **`input [15:0] scancode`**: Declares a 16-bit input named `scancode`.
*   **`output reg left, down, right, up`**: Declares four single-bit outputs, `left`, `down`, `right`, and `up`.  The `reg` keyword is used because these outputs are assigned values within an `always` block.
*   **`always @(*) begin ... end`**: This is a combinational `always` block.  The `*` means that the block will execute whenever any of the inputs change.  This is appropriate for this design because the outputs are directly determined by the input `scancode`.
*   **`case (scancode) ... endcase`**:  This `case` statement checks the value of `scancode`.
    *   Each `case` item checks for a specific scancode value (e.g., `16'he06b`).
    *   If the `scancode` matches, the corresponding output is set to `1'b1` (logic 1, asserted), and all other outputs are set to `1'b0` (logic 0, deasserted).
    *   The `default:` case handles the situation where the `scancode` does not match any of the arrow key scancodes.  In this case, all outputs are set to 0.

This complete specification and Verilog code should fulfill the requirements of the task.  Let me know if you have any questions or need any modifications!
Please only reply with the Verilog code after syntax check, no other words.
Please always begin with `module top_module()`.
```

