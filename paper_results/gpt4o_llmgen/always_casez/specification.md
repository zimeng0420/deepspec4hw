**Technical Specification for 8-Bit Priority Encoder**

**Module Name:** `top_module`  

**Inputs:**
- `in [7:0]`: 8-bit input vector (`in[0]` to `in[7]`), where each bit represents a binary signal.

**Outputs:**
- `pos [2:0]`: 3-bit output that indicates the position (0 to 7) of the first (least significant) bit that is high (`1`) in the input vector. If no bit is high, the output should be zero (`3'd0`).

**Functional Behavior:**
1. The encoder scans the input vector `in` from the least significant bit (`in[0]`) to the most significant bit (`in[7]`).
2. It identifies the first occurrence of a high (`1`) bit.
3. The position (index) of this bit is given as a 3-bit binary number on the output `pos`.
4. If none of the bits in the vector are high (`in == 8'b00000000`), `pos` should be set to `3'd0`.

**Encoding Priorities:**
- The least significant bit (`in[0]`) has the highest priority.
- The most significant bit (`in[7]`) has the lowest priority.

**Additional Requirements:**
- The registered outputs ensure the output `pos` remains consistent and stable for the next clock cycle if the input `in` changes.
- This priority encoder implementation does not account for invalid logic levels outside binary `0` and `1`.

**Considerations:**
- The implementation should avoid using latches by specifying all possible input conditions.
- The module does not include asynchronous or synchronous reset.
- The logic should efficiently cover all possible input combinations of the 8-bit input vector `in`.

**Note:** Adhere to best coding practices in Verilog design, ensuring synthesizability and optimal performance.