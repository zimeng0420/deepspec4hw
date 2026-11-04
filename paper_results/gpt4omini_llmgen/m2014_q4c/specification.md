### Technical Specification for D Flip-Flop with Active High Synchronous Reset

#### Module Name
`top_module`

#### Inputs
- **clk** (input): Clock signal (active edge-triggered).
- **d** (input): Data input signal that will be sampled on the rising edge of the clock.
- **r** (input): Active high synchronous reset signal. When asserted (high), it resets the output `q` to 0.

#### Outputs
- **q** (output logic): The output of the D flip-flop, reflecting the value of `d` on the rising edge of `clk`, unless reset.

#### Functionality
1. On the rising edge of the `clk`:
   - If `r` is high, set `q` to 0 (reset state).
   - If `r` is low, set `q` to the value of `d`.

#### Behavioral Description
- The D flip-flop will hold the input value `d` at output `q` when `r` is low. If `r` transitions to high, regardless of the state of `d`, `q` will immediately be set to 0. After the reset condition is removed (i.e., `r` is set to low), `q` will follow the value of `d` on subsequent rising edges of `clk`.

#### Implementation
Here’s the recommended Verilog implementation for the described D flip-flop:

```verilog
module top_module (
    input clk,
    input d,
    input r,
    output logic q
);
    always_ff @(posedge clk) begin
        if (r) begin
            q <= 0;  // Asynchronous reset active high
        end else begin
            q <= d;  // Capture the data input on the rising edge of clk
        end
    end
endmodule
```

#### Timing Characteristics
- **Setup time**: Time before the clock edge that `d` must be stable.
- **Hold time**: Time after the clock edge that `d` must remain stable.
- **Propagation delay**: Time from the clock edge to the valid output on `q`.

#### Synthesis Considerations
- Synthesize with consideration of timing requirements, ensuring that hold and setup times meet the specifications of the target FPGA/ASIC technology.
- Ensure that the reset functionality meets the asynchronous requirements during simulation and synthesis.