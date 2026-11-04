Technical Specification for 16-bit Input Half-Word Splitter:

Module Name:
```
top_module
```

Purpose:
- To design a combinational circuit in Verilog that splits a 16-bit input half-word into an upper byte and a lower byte.

Inputs:
- `in`: A 16-bit input vector representing the half-word to be split.
  - Type: wire [15:0]
  - Range: bit [15:0]

Outputs:
- `out_hi`: An 8-bit output vector representing the upper byte of the input half-word.
  - Type: wire [7:0]
  - Range: bit [15:8] of the input `in`
  
- `out_lo`: An 8-bit output vector representing the lower byte of the input half-word.
  - Type: wire [7:0]
  - Range: bit [7:0] of the input `in`

Design Requirements:
1. The circuit shall be purely combinational, producing the outputs based solely on the current input value.
2. The output `out_hi` should contain bits [15:8] of the input vector `in`.
3. The output `out_lo` should contain bits [7:0] of the input vector `in`.

Behavioral Description:
- If the 16-bit input vector `in` is divided into two bytes, with `in[15:8]` designated as the upper byte and `in[7:0]` as the lower byte:
  - Assign `out_hi` to `in[15:8]`
  - Assign `out_lo` to `in[7:0]`

Constraints:
- The circuit must not include any latches or flip-flops, ensuring it remains purely combinational.
- The design shall adhere to the specified module interface: `module top_module(input [15:0] in, output [7:0] out_hi, output [7:0] out_lo);`

Implementation:
- Use continuous assignments to map the input bits directly to the respective output buses:
  - `assign out_hi = in[15:8];`
  - `assign out_lo = in[7:0];`

Test Plan:
- Verify functionality across all possible 16-bit input values to ensure correct operation.
- Simulate the module behavior to confirm that output bytes accurately reflect the corresponding sections of the input half-word.

Target Technology:
- The design should be synthesizable for implementation in FPGAs or ASICs using standard digital design tools.