Technical Specification for Decade Counter:

1. **Module Definition:**
   - **Module Name:** top_module
   - **Inputs:**
     - `clk`: Clock signal, positive edge-triggered.
     - `slowena`: Control signal to enable counting. If high, the counter increments; if low, the counter holds its value.
     - `reset`: Active high synchronous reset signal.
   - **Output:**
     - `q`: A 4-bit register that holds the current count value (0 to 9 inclusive).

2. **Functionality:**
   - The counter should increment its value on the rising edge of the clock (`clk`) if `slowena` is high and the counter is not in a reset state.
   - On each rising edge of the clock:
     - If `reset` is high, the counter (`q`) shall be reset to 4'b0000.
     - If `reset` is low and `slowena` is high, the counter shall increment by 1, cycling back to 0 after reaching 9 (4'b1001).
     - If `reset` is low and `slowena` is low, the counter shall maintain its current value.

3. **Counter Behavior:**
   - **Reset Condition:** 
     - When `reset = 1`: Set `q` to 4'b0000 regardless of the state of `slowena`.
   - **Counting Condition:**
     - When `reset = 0` and `slowena = 1`:
       - If current count (`q`) is 4'b1001, next state should be 4'b0000 (wrapping from 9 to 0).
       - Otherwise, increment `q` by 1.
   - **Hold Condition:**
     - When `reset = 0` and `slowena = 0`: Maintain `q` at its current value.

4. **Edge Conditions:**
   - Ensure that the counter operates correctly on the positive edge of the clock signal.
   - Implement synchronous reset to prevent asynchronous behavior in reset conditions.

5. **Design Considerations:**
   - Ensure the counter does not glitch and maintains robustness across the counters' range (0 to 9).
   - Confirm the `q` output only toggles on the positive clock edge as specified, adhering to synchronous design principles.
   - Validate logical conditions to avoid unintended counter progression or stalling.
