## Technical Specification for Positive Edge-Triggered D Flip-Flop with Asynchronous Reset

### Module Name
- **top_module**

### Inputs
1. **clk**: Clock signal (1-bit)  
   - Type: `input`
   - Description: The positive edge on this signal will latch the value of 'd' to 'q'.

2. **d**: Data input (1-bit)  
   - Type: `input`
   - Description: This signal's value is latched into 'q' on the rising edge of 'clk' if 'ar' is not active.

3. **ar**: Asynchronous reset (1-bit)  
   - Type: `input`
   - Description: Active-high reset signal. When asserted, 'q' is immediately set to '0' regardless of other signals.

### Outputs
1. **q**: Data output (1-bit)  
   - Type: `output logic`
   - Description: This signal reflects the stored value of 'd' based on the clock and reset conditions.

### Functionality
- **Asynchronous Reset (`ar`)**: When `ar` is high, the output `q` is reset to `0` immediately, irrespective of the clock.
- **Clock Edge (`clk`)**: On the rising edge of `clk`, if `ar` is not active (`0`), the data input `d` is sampled and latched onto the output `q`.
- **Idle State**: When there are no clock edges and `ar` is low, the output `q` maintains its current state.

### Verilog Implementation

```verilog
module top_module (
    input clk,
    input d,
    input ar,
    output logic q
);

    always_ff @(posedge clk or posedge ar) begin
        if (ar) begin
            q <= 1'b0; // Asynchronous reset
        end else begin
            q <= d; // Latch data on clock edge
        end
    end

endmodule
```

### Key Notes
- **Sensitivity List**: Includes both `posedge clk` and `posedge ar`, ensuring the asynchronous reset can function independently of the clock to immediately set `q` to `0`.
- **Sequential Block**: `always_ff` is utilized for clarity and to emphasize the sequential nature of the flip-flop operations.
- **Asynchronous Reset Dominance**: The `if` statement prioritizes `ar`, ensuring that reset overrides the data latching feature.