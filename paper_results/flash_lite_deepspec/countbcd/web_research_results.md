# Web Research Results

Total Results: 1

## Result 1

A BCD counter is a 4-bit binary counter that counts from 0 to 9 and then resets. Each decimal digit is represented using 4 bits.

Here's a module definition for a 4-digit BCD counter with enable signals, a synchronous active-high reset, and the specified interface:

```verilog
module top_module(
    input clk,
    input reset,
    output [3:1] ena,
    output reg [15:0] q
);

// Internal signals for each BCD digit
reg [3:0] ones_digit;
reg [3:0] tens_digit;
reg [3:0] hundreds_digit;
reg [3:0] thousands_digit;

// Enable signals
assign ena[1] = (ones_digit == 9); // Enable tens digit when ones digit rolls over
assign ena[2] = (tens_digit == 9) && (ones_digit == 9); // Enable hundreds digit when tens and ones digits roll over
assign ena[3] = (hundreds_digit == 9) && (tens_digit == 9) && (ones_digit == 9); // Enable thousands digit when hundreds, tens, and ones digits roll over

// Counter logic for ones digit
always @(posedge clk or posedge reset) begin
    if (reset)
        ones_digit <= 4'd0;
    else if (ena[1]) // Increment tens digit when ones digit rolls over
        ones_digit <= 4'd0;
    else if (ones_digit < 9)
        ones_digit <= ones_digit + 1;
    else
        ones_digit <= 4'd0;
end

// Counter logic for tens digit
always @(posedge clk or posedge reset) begin
    if (reset)
        tens_digit <= 4'd0;
    else if (ena[2]) // Increment hundreds digit when tens digit rolls over
        tens_digit <= 4'd0;
    else if (ena[1] && ones_digit == 9) // Increment tens digit when ones digit rolls over
        if (tens_digit < 9)
            tens_digit <= tens_digit + 1;
        else
            tens_digit <= 4'd0;
end

// Counter logic for hundreds digit
always @(posedge clk or posedge reset) begin
    if (reset)
        hundreds_digit <= 4'd0;
    else if (ena[3]) // Increment thousands digit when hundreds digit rolls over
        hundreds_digit <= 4'd0;
    else if (ena[2] && tens_digit == 9 && ones_digit == 9) // Increment hundreds digit when tens digit rolls over
        if (hundreds_digit < 9)
            hundreds_digit <= hundreds_digit + 1;
        else
            hundreds_digit <= 4'd0;
end

// Counter logic for thousands digit
always @(posedge clk or posedge reset) begin
    if (reset)
        thousands_digit <= 4'd0;
    else if (ena[3] && hundreds_digit == 9 && tens_digit == 9 && ones_digit == 9)
        if (thousands_digit < 9)
            thousands_digit <= thousands_digit + 1;
        else
            thousands_digit <= 4'd0;
end

// Concatenate digits to form the output
always @(*) begin
    q = {thousands_digit, hundreds_digit, tens_digit, ones_digit};
end

endmodule
```

Key aspects of the design:

*   **Module Definition:** The code adheres to the provided module definition, including input and output ports.
*   **BCD Counters:** Four separate 4-bit registers (`ones_digit`, `tens_digit`, `hundreds_digit`, `thousands_digit`) are used to represent each BCD digit.
*   **Enable Signals:** The `ena` signals are generated based on the carry-out of the lower-order digits. For example, `ena[1]` is asserted when the `ones_digit` reaches 9, indicating that the `tens_digit` should be incremented.
*   **Synchronous Reset:** The `reset` signal is used to synchronously reset all the digits to 0.
*   **Counting Logic:** Each digit increments on the rising edge of the clock. The ones digit increments normally. The tens digit increments when `ena[1]` is high (ones digit rolls over). The hundreds digit increments when `ena[2]` is high (tens digit rolls over), and so on.
*   **Output:** The `q` output is formed by concatenating the four BCD digits.



---

