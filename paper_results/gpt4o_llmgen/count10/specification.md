# Technical Specification for Decade Counter Module

### Module Name
`top_module`

### Description
This module implements a decade counter that counts from 0 to 9 (decimal), which corresponds to the 4-bit binary range from 0000 to 1001. The counter has a period of 10. It includes an active-high synchronous reset feature that sets the counter to 0 when activated.

### Ports
1. **clk**: 
   - Direction: Input
   - Width: 1 bit
   - Description: Clock signal for the counter. The counter increments on each rising edge of this signal.

2. **reset**: 
   - Direction: Input
   - Width: 1 bit
   - Description: Active-high synchronous reset input. When high, the counter is reset to 0 on the rising edge of `clk`.

3. **q**: 
   - Direction: Output
   - Width: 4 bits
   - Description: Outputs the current 4-bit counter value. Represents decimal values 0 through 9.

### Behavior
- **Count**: On each rising edge of the `clk` signal, the counter `q` increments by 1 if the reset input is low.
- **Count Range**: The counter rolls over from 9 (b1001) back to 0 upon receiving the next clock pulse.
- **Reset**: If `reset` is set to high, the counter `q` is immediately loaded with 0 synchronously with the clock.

### Operations
- **Increment Operation**: 
  - If `reset` is low, increment `q` by 1 on the rising edge of `clk`.
  - Example Transition: 0000 -> 0001 -> ... -> 1001 -> 0000
- **Reset Operation**: 
  - If `reset` is high during the rising edge of `clk`, set `q` to 0000, regardless of its current value.

### Additional Information
- Counter width is 4 bits to accommodate the maximum binary value of 1001.
- Synchronous reset ensures that the counter resets predictably in alignment with the clock edge.
- The design ensures low hardware complexity suitable for implementation on FPGA or ASIC platforms.

This specification should be used as a guideline to construct the Verilog module, ensuring a correct counting sequence and reset functionality as described.