```verilog
module top_module(
    input clk,
    input d,
    output reg q
);

    always @(posedge clk) begin
        q <= d; // On the rising edge of clk, update q with the value of d
    end

endmodule
``` 

### Technical Specifications:
- **Module Name**: top_module
- **Inputs**:
  - `clk`: Clock signal (Input, type: wire)
  - `d`: Data input signal (Input, type: wire)
- **Outputs**:
  - `q`: Output signal, which holds the value of `d` at the last clock edge (Output, type: reg)
- **Behavior**:
  - On the rising edge of the `clk` signal, the value of the `d` input is sampled and stored in the output register `q`. 
  - This behavior creates a D flip-flop functionality, where `q` retains the value of `d` until the next rising edge of `clk`.
- **Synthesis**: The module synthesizes to a D flip-flop in hardware description language (HDL) environments.
- **Timing**: Ensure that the clock signal meets setup and hold time requirements for reliable operation in a physical circuit.