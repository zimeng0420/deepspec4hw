### Technical Specification for a Decade Counter Module

**Module Name:** `top_module`

**Functionality:**
- This module implements a decade counter that counts from 0 to 9, inclusive.
- The counting operation is synchronized to the rising edge of the clock signal `clk`.
- The counter resets to 0 upon receiving an active high reset signal.

**Inputs:**
- `input clk`: Clock signal for synchronization. The counter increments on the rising edge.
- `input reset`: Active high synchronous reset signal that resets the counter to 0.

**Outputs:**
- `output reg [3:0] q`: 4-bit output representing the current count value from 0 to 9.

**Behavior:**
1. **Count Sequence:**
   - The counter shall increment (q = q + 1) on the rising edge of the clock when the reset is not active.
   - Upon counting to 9 (i.e., q = 9), the next count will reset back to 0 (i.e., q = 0).
   
2. **Reset Behavior:**
   - When the reset input is high (reset = 1), the counter should immediately reset to 0 on the next rising edge of the clock.
   - While the reset signal is asserted (high), any clock cycles should not affect the counter state.

**Constraints:**
- Ensure that the count only increments while the reset is low (active low).
- Maintain proper clock edge triggering to avoid counting errors.

**Assumptions:**
- The clock frequency is stable and meets the requirements of the counting application.
- The reset signal is properly debounced if applied physically.

**Notes:**
- The counter can be implemented using a series of flip-flops or any hardware logic that supports the required counting function.
- Consider edge cases, such as simultaneous toggling of reset and clock signals.

### Sample Code Structure:
```verilog
module top_module(
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000; // Reset to 0
    end else if (q == 4'b1001) begin
        q <= 4'b0000; // Roll over after 9
    end else begin
        q <= q + 1; // Increment count
    end
end

endmodule
```

This specification outlines the functional and implementation details necessary for the construction of a decade counter in Verilog.