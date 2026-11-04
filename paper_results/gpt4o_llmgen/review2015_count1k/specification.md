Technical Specification:

1. **Module Name:** `top_module`

2. **Inputs:**
   - `clk`: Clock input used to drive the counter. It should be a single-bit binary signal.
   - `reset`: Active high synchronous reset input. Resets the counter to 0 when asserted. It should be a single-bit binary signal.

3. **Outputs:**
   - `q`: A 10-bit wide output signal representing the current count value of the counter. The range is from 0 to 999, inclusive.

4. **Counter Characteristics:**
   - **Bit Width:** The counter should have a width of 10 bits, allowing it to count from 0 to 999 in binary.
   - **Counting Range:** Counts incrementally from 0 to 999. After reaching 999, it wraps around to 0.
   - **Period:** The counter completes a full cycle every 1000 clock cycles.
   
5. **Reset Behavior:**
   - **Synchronous Reset:** The reset signal is synchronous with the clock, meaning it only resets the counter on a rising edge of the clock if `reset` is high.
   - **Active High:** Asserts and resets the counter to 0 when the `reset` input is high during a clock edge.

6. **Clock Edge Sensitivity:**
   - Counter increments on the rising edge of the clock signal (`clk`).

7. **Functional Description:**
   - On each rising edge of the clock, if the `reset` input is high, reset the counter output `q` to 0.
   - If `reset` is not asserted, increment the current value of `q` by 1.
   - If `q` reaches 999, the next count value should wrap around back to 0.

8. **Implementation Details:**
   - Utilize a `reg` type for `q` to enable storage and updating of the counter value.
   - Implement synchronous logic to ensure correct operation of reset and counting based on the clock signal.
   - Ensure wrap-around behavior from 999 to 0.

9. **Additional Requirements:**
   - Ensure proper synthesis-friendly design, avoiding combinational loops or latching behavior.
   - Include comments or assertions, if necessary, for synthesis tools or ease of understanding by other engineers.

By following these specifications, the resulting module should perform as a synchronous 10-bit counter with reset functionality, suitable for a wide range of applications that require counting cycles up to 999.