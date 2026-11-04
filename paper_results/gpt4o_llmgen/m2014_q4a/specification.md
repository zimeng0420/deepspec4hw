Technical Specification: D Latch Implementation using an Always Block

Objective:
To implement a D latch using an always block in Verilog that adheres to the provided module header specification. The D latch should update its output based on the enable signal and the input data signal.

Design Requirements:

1. **Input Ports:**
   - `d`: 1-bit input, representing the data input to the latch.
   - `ena`: 1-bit input, representing the enable signal for the latch.

2. **Output Ports:**
   - `q`: 1-bit output, representing the current state of the latch.

3. **Functionality:**
   - The latch should update its output (`q`) to match the input data (`d`) only when the enable signal (`ena`) is active (logic high).
   - When the enable signal (`ena`) is inactive (logic low), the output (`q`) should retain its last state.

4. **Sensitivity List:**
   - The always block should be sensitive to changes in the `ena` and `d` signals to ensure that the functionality of the D latch is accurately represented.

5. **Implementation Details:**
   - Use a synchronous always block to handle the logic of the D latch, ensuring that it follows the specified enable-based behavior.
   - Incorporate necessary logic to maintain the state of the latch when the enable signal is low.

6. **Constraints:**
   - Synthesizeable design that can be implemented in FPGA or ASIC environments.
   - Utilize minimal resources to achieve the functionality, optimizing for both area and performance.

7. **Code Outline:**
   - Within the always block, conditionally update the `q` output based on the state of the `ena` signal.
   - Ensure proper initialization if required by synthesis tools or specific design environments.

8. **Testing and Verification:**
   - Create a testbench to simulate the D latch behavior, verifying correct state retention and update behavior under different combinations of `d` and `ena`.

9. **Compliance:**
   - Follow best practices for coding and commenting to make the implementation clear, maintainable, and easily understandable.
