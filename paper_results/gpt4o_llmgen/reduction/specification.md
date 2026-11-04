## Technical Specification for 8-bit Even Parity Generator

### Module Name:
`top_module`

### Inputs:
- **in [7:0]:** A vector input consisting of 8 bits, `in[7]` through `in[0]`.

### Outputs:
- **parity:** A single-bit output that represents the even parity bit for the input byte.

### Functional Requirements:
1. **Parity Calculation:**
   - The even parity bit is determined by performing an XOR operation across all 8 input bits.
   - If the total number of 1's in the input is even, the parity bit should be 0.
   - If the total number of 1's in the input is odd, the parity bit should be 1.

2. **Equation:**  
   The parity bit should be calculated as:  
   ```
   parity = in[7] ^ in[6] ^ in[5] ^ in[4] ^ in[3] ^ in[2] ^ in[1] ^ in[0]
   ```

### Implementation Details:
- The design should use structural Verilog syntax to define the logic operation.
- The XOR reduction operator can be utilized to simplify the computation of the parity bit.

### Example:
- For an input `in = 8'b10110010`, the parity bit calculation should be `1 ^ 0 ^ 1 ^ 1 ^ 0 ^ 0 ^ 1 ^ 0 = 0`. Hence, the output `parity` should be 0.

### Expected Timing:
- The parity computation should be combinational logic with no internal storage or state. Thus, it should update immediately as the input vector changes.

### Constraints:
- The design should be synthesizable for FPGA implementation.
- Avoid using sequential logic or flip-flops since the operation is combinational.

### Deliverables:
- A Verilog module named `top_module` correctly following the specified input/output interface and functional requirements.
- Ensure proper coding standards and annotations for readability and maintainability.