# Technical Specification for D Flip-Flop with Active High Synchronous Reset

## Overview
Design and implement a simple D-type flip-flop with an active high synchronous reset function. The output (`q`) will be reset to 0 when the reset signal (`r`) is high during a positive clock edge transition.

## Module Definition

### Module Name
`top_module`

### Ports

- **clk** (input): Clock signal, the trigger for the flip-flop operation (positive edge-triggered).
- **d** (input): Data input to the flip-flop.
- **r** (input): Active high synchronous reset signal. When high, `q` will be reset on the next positive clock edge.
- **q** (output, logic): The output of the flip-flop, which holds the stored data value or reset value as per the signal conditions.

### Port Width
- All ports are single-bit signals.

## Functional Requirements

1. **Clock Edge Sensitivity**: The flip-flop should capture the input data (`d`) on the positive edge of the clock (`clk`).

2. **Synchronous Reset**:
   - When `r` is high at the time of a positive clock edge, the output (`q`) should be reset to 0.
   - If `r` is low during a positive clock edge, `q` should capture and hold the value of `d`.

3. **Output**: 
   - The output (`q`) must maintain its state between clock transitions unless updated by the data input or reset condition on a positive clock edge.

## Behavioral Description

### Timing Conditions
- On each rising edge of `clk`:
  - If `r` is high, then `q` should be set to 0.
  - Otherwise, `q` should take the value of `d`.

### Reset Operation
- The reset operation (`r`) is synchronous and evaluated only at the rising edge of `clk`.

### Logic Level
- Implemented using procedural blocks to ensure synchronization with the clock edge.

## Technological Considerations

- Use of sequential logic constructs is required to maintain the data between the clock edges.
- Ensure that the design is synthesizable with commonly used synthesis tools for FPGA and ASIC designs.

## Code Implementation Sketch

```verilog
module top_module (
    input clk,
    input d,
    input r,
    output logic q
);

    always_ff @(posedge clk) begin
        if (r) begin
            q <= 1'b0;
        end else begin
            q <= d;
        end
    end

endmodule
```

## Additional Considerations

- Ensure the design meets the specified setup and hold time requirements for the `d` input relative to the `clk` signal.
- Verification through simulation is advised to confirm functional behavior across various input scenarios.
- The module is designed to be compatible with standard digital design flows and can be easily integrated into larger systems. 

This technical specification is aimed at ensuring the correct and efficient implementation of a D flip-flop with active high synchronous reset within a digital system.