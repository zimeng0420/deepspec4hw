```verilog
module top_module(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);
    
    // Internal signals for D flip-flops
    reg [15:0] d_flops;

    // Always block for synchronous D flip-flop behavior
    always @(posedge clk) begin
        if (!resetn) begin
            // Reset all flip-flops to 0 on active-low reset
            d_flops <= 16'b0;
        end else begin
            // Upper byte: d[15:8]
            if (byteena[1]) begin
                d_flops[15:8] <= d[15:8];
            end
            // Lower byte: d[7:0]
            if (byteena[0]) begin
                d_flops[7:0] <= d[7:0];
            end
        end
    end

    // Output assignment
    always @* begin
        q = d_flops; // Assign the stored values in D flip-flops to output
    end

endmodule
```

### Technical Specification:
1. **Module Interfaces**:
    - Input Ports:
        - `clk`: Clock input (synchronous).
        - `resetn`: Active-low synchronous reset.
        - `byteena[1:0]`: Control signals for enabling writes to upper and lower bytes.
        - `d[15:0]`: Data input to the flip-flops.
    - Output Ports:
        - `q[15:0]`: Output register holding the values of the 16 D flip-flops.

2. **D Flip-Flops**:
    - Total of 16 D flip-flops created to store 16-bit values.
    - Each flip-flop is triggered on the positive edge of the `clk` signal.

3. **Reset Functionality**:
    - The reset is synchronous and active-low. When `resetn` is low, all outputs `q` will reset to `0`.

4. **Byte Enable Functionality**:
    - The `byteena` signal determines which bytes of the flip-flops are written to:
        - `byteena[1]` writes to `d[15:8]` (upper byte).
        - `byteena[0]` writes to `d[7:0]` (lower byte).

5. **Data Flow and Output**:
    - The contents of the D flip-flops (`d_flops`) are continuously assigned to the output `q`, reflecting current data stored.

6. **Implementation Constraints**:
    - Ensure proper clock and reset handling to maintain stable and correct flip-flop operation.
    - Ensure that concurrent writes to the same byte do not cause data inconsistencies.

This specification provides a modular and scalable approach to implementing a 16-bit register bank with selective write capabilities, suitable for integration into larger digital systems.