**Technical Specification for 6-to-1 Multiplexer:**

**Module Name:** `top_module`

**Inputs:**
1. `sel` - A 3-bit input used to select which data input is routed to the output. Valid range for selection is 0 to 5.
2. `data0` - A 4-bit data input.
3. `data1` - A 4-bit data input.
4. `data2` - A 4-bit data input.
5. `data3` - A 4-bit data input.
6. `data4` - A 4-bit data input.
7. `data5` - A 4-bit data input.

**Output:**
- `out` - A 4-bit output that reflects the selected data input value.

**Functional Requirements:**
- The multiplexer must output one of the six 4-bit data inputs (`data0` to `data5`) based on the value of the `sel` input.
- If the `sel` input has a value between 0 and 5, the multiplexer will output the corresponding data input:
  - `sel = 3'b000` will output `data0`
  - `sel = 3'b001` will output `data1`
  - `sel = 3'b010` will output `data2`
  - `sel = 3'b011` will output `data3`
  - `sel = 3'b100` will output `data4`
  - `sel = 3'b101` will output `data5`
- If the `sel` input is any value outside the valid range (i.e., 6 or 7), the multiplexer will output `4'b0000`.

**Operational Conditions:**
- The signal transition and selection must be synchronous to input signal changes.
- The multiplexer does not include any internal flip-flops or memory elements and operates purely based on combinational logic.

**Constraints:**
- Ensure minimal propagation delay to optimize for speed as it is purely a combinatorial circuit.
- The module should be self-contained with no dependencies on external libraries or systems beyond standard Verilog.

**Example Use Case:**
- If `sel = 3'b010`, the output `out` should be equal to the value of `data2`.
- If `sel = 3'b110`, the output `out` should be `4'b0000` as 6 is outside the designated selection range. 

The design should reflect efficient hardware usage and clear priority assignment to `sel` conditions.