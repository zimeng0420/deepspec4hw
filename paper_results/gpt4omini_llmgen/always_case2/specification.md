### Technical Specification for 4-bit Priority Encoder in Verilog

**Module Name:** `top_module`

**Inputs:**
- `in`: A 4-bit input vector (`in[3:0]`), where each bit represents a different input. The index represents the priority, with `in[3]` being the highest priority (most significant) and `in[0]` being the lowest priority (least significant).

**Outputs:**
- `pos`: A 2-bit output vector (`pos[1:0]`), indicating the position of the highest priority bit set to `1`. If all inputs are `0`, `pos` should be `2'b00`.

**Behavior:**
1. The module should continuously monitor the `in` inputs.
2. The output `pos` should reflect the position of the highest-order `1` bit in the input. The positions are defined as:
   - `2'b00` corresponds to `in[0]`
   - `2'b01` corresponds to `in[1]`
   - `2'b10` corresponds to `in[2]`
   - `2'b11` corresponds to `in[3]`
3. If all bits in `in` are `0`, then `pos` should output `2'b00`.

**Functionality:**
- The encoder prioritizes the bits from `in[3]` to `in[0]`.
- The output is determined as follows:
  - If `in[3]` is `1`, output `pos` as `2'b11`
  - If `in[2]` is `1`, output `pos` as `2'b10`
  - If `in[1]` is `1`, output `pos` as `2'b01`
  - If `in[0]` is `1`, output `pos` as `2'b00`
  - If `in` is `4'b0000`, output `pos` as `2'b00`

**Implementation Considerations:**
- Use a combinational logic approach to generate the output based on the input vector.
- Ensure that in case of parallel recognition (multiple bits set), the highest priority bit is recognized.

**Example Inputs and Outputs:**
- For `in = 4'b1000` → `pos = 2'b11`
- For `in = 4'b0100` → `pos = 2'b10`
- For `in = 4'b0010` → `pos = 2'b01`
- For `in = 4'b0001` → `pos = 2'b00`
- For `in = 4'b0000` → `pos = 2'b00`

**Testing:**
- Create a testbench that applies all possible combinations of the 4-bit input and checks the correctness of the output against the specification.

This specification provides a clear guide for the design and implementation of a 4-bit priority encoder in Verilog.