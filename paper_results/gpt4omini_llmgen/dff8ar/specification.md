```verilog
module top_module(
    input clk,
    input [7:0] d,
    input areset,
    output reg [7:0] q
);

    // Always block sensitive to the rising edge of clk or the areset signal
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Asynchronous reset: set output to 0
            q <= 8'b0;
        end else begin
            // On the rising edge of clk, assign input d to output q
            q <= d;
        end
    end
    
endmodule
``` 

### Technical Specification:
1. **Module Name**: top_module
2. **Inputs**:
   - `clk`: Clock signal (1-bit).
   - `d`: Data input (8-bit).
   - `areset`: Asynchronous reset signal (1-bit).
   
3. **Output**:
   - `q`: Output of the D flip-flops (8-bit).

4. **Functional Requirements**:
   - Implement 8 D flip-flops that capture the input `d` on the positive edge of `clk`.
   - Provide an active-high asynchronous reset (`areset`) functionality that resets all output bits of `q` to `0` whenever `areset` is high.
   
5. **Behavior**:
   - On the rising edge of `clk`:
     - If `areset` is high, output `q` is set to `0`.
     - If `areset` is low, output `q` is updated with the value of input `d`. 

6. **Synthesis Constraints**:
   - Ensure that the design is synthesizable and produces a hardware implementation with 8 synchronous D flip-flops and proper reset logic.

7. **Simulation Requirements**:
   - Provide testbench to validate the functionality of reset and clock-triggered data capture.

8. **Operating Conditions**:
   - Verify functionality under standard operating conditions of the target technology (timing, voltage levels).
  
9. **Test Cases**:
   - Reset during clock high and low.
   - Data capture at given clock edges with and without reset.

10. **Documentation**:
    - Provide inline comments within the code for future reference and maintenance.

11. **Additional Notes**:
    - Ensure that no race conditions exist due to asynchronous reset and clock logic.