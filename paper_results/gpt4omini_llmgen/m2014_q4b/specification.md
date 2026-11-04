Here is the technical specification for implementing a D flip-flop with the specified requirements:

### Technical Specification:

1. **Module Name**: top_module

2. **Inputs**:
   - `clk`: This is the clock input (positive edge-triggered).
   - `d`: This is the data input that will be sampled on the rising edge of the clock.
   - `ar`: This is the asynchronous reset input. When asserted (high), it will reset the output `q` to `0` regardless of the clock edge.
  
3. **Output**:
   - `q`: This output holds the value of the D flip-flop, reflecting the state of the input `d` at the last clock edge if `ar` is not asserted.

4. **Behavior**:
   - The flip-flop should reset asynchronously when `ar` is high, setting `q` to `0`.
   - On the rising edge of `clk`, if `ar` is low, `q` should take on the value of `d`.

5. **Implementation Details**:
   - Use a non-blocking assignment (`<=`) for the flip-flop behavior to ensure proper simulation of the edge-triggered functionality.
   - The asynchronous reset should be handled in a conditional statement to prioritize its operation over the clock triggering.

6. **Verilog Code**:
   - The implementation should follow Verilog synthesis best practices.

### Example Verilog Code:

```verilog
module top_module (
    input clk,
    input d,
    input ar,
    output logic q
);

    always_ff @(posedge clk or posedge ar) begin
        if (ar) begin
            q <= 1'b0;   // Asynchronous reset
        end
        else begin
            q <= d;      // Capture data on positive edge of clk
        end
    end
    
endmodule
```

### Notes:
- Ensure the sensitivity list includes both the clock and the asynchronous reset input.
- The output `q` will reflect either the reset state or the sampled input `d` based on the current conditions.