## Technical Specification for 4-digit BCD Counter

### Module Description:
Design a 4-digit Binary-Coded Decimal (BCD) counter implemented in Verilog. Each decimal digit is encoded in 4 bits, and the counter supports synchronous counting with an active-high reset. The counter also provides enable signals for the upper three digits to indicate when they should be incremented.

### Interface:

#### Inputs:
- `clk`: Clock input, used to drive synchronous increments.
- `reset`: Active-high reset signal. When `reset` is high, the counter resets to 0.

#### Outputs:
- `ena[3:1]`: Enable signals for the digits tens, hundreds, and thousands (q[7:4], q[11:8], q[15:12]).
  - `ena[1]`: Indicates when the tens digit (q[7:4]) should be incremented.
  - `ena[2]`: Indicates when the hundreds digit (q[11:8]) should be incremented.
  - `ena[3]`: Indicates when the thousands digit (q[15:12]) should be incremented.
- `q[15:0]`: 16-bit register representing the 4-digit BCD counter.
  - `q[3:0]`: Ones digit.
  - `q[7:4]`: Tens digit.
  - `q[11:8]`: Hundreds digit.
  - `q[15:12]`: Thousands digit.

### Operation:
1. **Reset**: 
   - When the `reset` input is high, the counter value `q` is reset to 0 (`q` = 16'b0000_0000_0000_0000).

2. **Counting**:
   - On every rising edge of the `clk`, the following operations occur:
     - The ones digit (q[3:0]) increments by 1.
     - If q[3:0] reaches 9, it rolls over to 0, and `ena[1]` is set high.
     - If `ena[1]` is high, q[7:4] (tens) increments by 1.
     - If q[7:4] reaches 9 and `ena[1]` is high, it rolls over to 0, and `ena[2]` is set high.
     - If `ena[2]` is high, q[11:8] (hundreds) increments by 1.
     - If q[11:8] reaches 9 and `ena[2]` is high, it rolls over to 0, and `ena[3]` is set high.
     - If `ena[3]` is high, q[15:12] (thousands) increments by 1.
     - If q[15:12] reaches 9 and `ena[3]` is high, it rolls over to 0.

3. **Enable Signals**:
   - `ena[1]` is asserted (1) when the ones digit wraps around from 9 to 0.
   - `ena[2]` is asserted (1) when the tens digit wraps around from 9 to 0, and `ena[1]` is high.
   - `ena[3]` is asserted (1) when the hundreds digit wraps around from 9 to 0, and `ena[2]` is high.

### Constraints:
- Ensure the BCD digits roll over appropriately at 9 and provide correct enable signals for each upper digit.
- Utilize synchronous logic to ensure deterministic behavior based on `clk` and `reset`.

### Additional Notes:
- Care should be taken for each digit to only roll over at 9, maintaining valid BCD states (0-9 per digit).
- The design should be efficient and suitable for synthesis on standard FPGA or ASIC platforms.