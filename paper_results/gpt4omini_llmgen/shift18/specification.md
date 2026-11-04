### Technical Specification for 64-bit Arithmetic Shift Register with Synchronous Load

#### Module Definition
- **Module Name:** `top_module`
- **Functionality:** 64-bit arithmetic shift register with synchronous load and configurable shift direction and amount.

#### Input Signals
1. **clk (1-bit)**:
   - Description: Clock signal for synchronizing operations.
   - Edge Trigger: Rising edge.

2. **load (1-bit)**:
   - Description: Load control signal to load the register with the provided data.
   - Active State: High (1).

3. **ena (1-bit)**:
   - Description: Enable control signal for shifting the register contents.
   - Active State: High (1).

4. **amount (2-bit)**:
   - Description: Determines the direction and amount of shift operation.
   - Encoding:
     - `2'b00`: Shift left by 1 bit.
     - `2'b01`: Shift left by 8 bits.
     - `2'b10`: Shift right by 1 bit (arithmetic).
     - `2'b11`: Shift right by 8 bits (arithmetic).

5. **data (63:0)**:
   - Description: Input data to be loaded into the register when `load` is high.

#### Output Signal
1. **q (63:0)**:
   - Description: Register output that contains the current value of the shift register after load or shift operations.

#### Operations
1. **Loading Data**:
   - When `load` is high, irrespective of the state of `ena`, the output `q` will be loaded with the value from `data`.

2. **Shifting Data**:
   - When `ena` is high and `load` is low, the shift register performs shifting operations based on the `amount` input.
   - Shifting occurs on the rising edge of the clock:
     - If `amount` is `2'b00`: Shift `q` left by 1 position, filling the LSB with 0.
     - If `amount` is `2'b01`: Shift `q` left by 8 positions, filling the LSBs with 0.
     - If `amount` is `2'b10`: Shift `q` right by 1 position, filling the MSB with the current MSB (arithmetic shift).
     - If `amount` is `2'b11`: Shift `q` right by 8 positions, filling the MSB with the current MSB (arithmetic shift).

#### Initial Condition
- The module's contents of `q` should be initialized to zero `64'b0` on system reset or for simulation purposes.

#### Implementation Requirements
- Use appropriate registers and combinatorial logic to ensure that the operations are performed correctly based on the clock edges and input signals.
- Ensure that the shifting logic correctly maintains the sign during arithmetic shifts.

#### Edge Cases
- Ensure to handle simultaneous `load` and `ena` signals as per the defined priority (load should take precedence).
  
#### Test Cases
- Create comprehensive test cases to validate loading behavior, left shifting, and arithmetic right shifting under various conditions for correctness.