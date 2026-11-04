```verilog
module top_module(
    input clk,            // Clock input
    input reset,         // Active high synchronous reset input
    output reg [9:0] q   // 10-bit output to hold the counter value
);

    // Internal register to store the counter value
    reg [9:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 10'd0;   // Reset the counter to 0 when reset is high
        end 
        else if (count < 10'd999) begin
            count <= count + 1; // Increment the counter
        end
        // The counter will not increment beyond 999, hence no additional logic needed
    end

    assign q = count; // Assigning the current count value to output q

endmodule
``` 

### Technical Specifications:
- **Counter Range**: 0 to 999
- **Output Width**: 10 bits (to accommodate values from 0 to 999)
- **Reset Behavior**: 
  - Active high synchronous reset
  - Resets output to 0 when `reset` is high
- **Counting Period**: 
  - Increments count value on each positive edge of the clock
  - Counter does not wrap around; stops incrementing at 999
- **Behavior on Reset**:
  - The counter is reset to 0 immediately upon receiving a reset signal, regardless of the clock state.
- **Synthesis Considerations**:
  - Optimize for area and power where possible, ensuring a single clock cycle per count increment.
- **Testbench Needs**: Ensure to simulate the counter for cases including reset, normal counting, and edge cases (999 to 0 transition).