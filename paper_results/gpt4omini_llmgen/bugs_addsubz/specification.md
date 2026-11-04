```verilog
// synthesis verilog_input_version verilog_2001
module top_module (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    always @(*) begin
        // Compute the output based on the do_sub signal
        if (do_sub == 1) begin
            out = a - b;  // Subtraction
        end else begin
            out = a + b;  // Addition
        end

        // Set the result_is_zero flag based on the output
        result_is_zero = (out == 8'b00000000); // Check if out is zero
    end

endmodule
```

### Technical Specifications
1. **Inputs:**
   - `do_sub`: 1-bit control signal that determines whether to perform addition (0) or subtraction (1).
   - `a`: 8-bit input operand.
   - `b`: 8-bit input operand.

2. **Outputs:**
   - `out`: 8-bit result of the operation (either `a + b` or `a - b`).
   - `result_is_zero`: 1-bit flag indicating whether the result `out` is zero.

3. **Functional Requirements:**
   - The module should perform addition if `do_sub` is 0 and perform subtraction if `do_sub` is 1.
   - The module should correctly compute and display the output based on the operation selected.
   - The module should set the `result_is_zero` output high (1) if the result of the operation is `0` and low (0) otherwise. 

4. **Behavior:**
   - The operation should be combinational, updating output values immediately when inputs change.
   - The module should handle the edge case where both inputs are zero or result in zero after operation.

5. **Synthesis Constraints:**
   - The design should fit within standard 8-bit arithmetic operations and support synthesis onto FPGA or ASIC hardware.

6. **Fault Handling:**
   - Verify that no overflow occurs for addition and subtraction within the 8-bit range during synthesis and simulation. 

This structure ensures that the adder-subtractor works correctly and the zero flag operates as intended.