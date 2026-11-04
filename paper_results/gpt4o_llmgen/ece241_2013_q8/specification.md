## Technical Specification for a Mealy-Type FSM to Recognize Sequence "101"

### Module Header
- **Module Name:** `top_module`
- **Clock Input:** `clk`
- **Asynchronous Reset Input (Active Low):** `aresetn`
- **Input Signal:** `x`
- **Output Signal:** `z`

### Finite State Machine Details
- **Type:** Mealy
- **Number of States:** 3

### FSM State Definitions
1. **State S0:** Initial state or reset state where the FSM waits for a '1'.
   - **Output:** `z = 0`
   - **Transition Conditions:**
     - `x = 1`: Transition to State S1
     - `x = 0`: Stay in State S0

2. **State S1:** Detected the first '1' of the sequence.
   - **Output:** `z = 0`
   - **Transition Conditions:**
     - `x = 0`: Transition to State S2
     - `x = 1`: Stay in State S1

3. **State S2:** Detected "10", waiting for the final '1'.
   - **Output:** `z = 0`
   - **Transition Conditions:**
     - `x = 1`: Transition to State S3, sequence complete
     - `x = 0`: Transition back to State S0

4. **State S3:** Complete "101" sequence detected.
   - **Output:** `z = 1`
   - **Transition Conditions:**
     - Since this is a Mealy machine, the output `z` is asserted during the transition.
     - Transition from S2 to S1: `x = 1`, if the next `x = 0`: output remains 1 during edge

### Reset Behavior
- **Negative Edge Triggered Asynchronous Reset:** The FSM transitions to State S0 whenever `aresetn` is low, regardless of the clock or input `x`.

### Output Specifications
- **Output Signal `z`:**
  - Asserts to `1` during the output transition from State S2 to State S1 when the input `x` is `1` (Mealy transition).
  - Otherwise, `z = 0`.

### Implementation Constraints
- The FSM must be implemented using regular Verilog syntax and constructs. Utilize case statements or similar FSM support constructs to define transitions and state behavior.
- Ensure that the negative edge-triggered reset correctly initializes the FSM to State S0.

### State Transition Table
- Transitions must accommodate any input changes as specified, effectively recognizing overlapping sequences.
  - Example: Given input sequence `110101`, the outputs should trigger following detected "101" sequences accurately, respecting the Mealy nature of the output.

### Validation
- Ensure thorough testbench coverage to simulate various input sequences, including overlapping sequences and asynchronous reset conditions, verifying correct assertion of the output signal `z`.