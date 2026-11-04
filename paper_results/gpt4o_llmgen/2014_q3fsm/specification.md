Technical Specification:

1. **State Definitions:**
   - **State A:** Reset/Initial state. 
     - Transition: Remain in state A when s = 0. Transition to state B when s = 1.
   - **State B:** Initial state to start monitoring w over three clock cycles.
   - **State C:** Intermediate state to count first occurrence of w = 1.
   - **State D:** Intermediate state to count second occurrence of w = 1.
   - **State E:** Final verification state to check the number of times w = 1 over three clock cycles.

2. **Inputs:**
   - `clk`: Clock input for synchronous state transitions.
   - `reset`: Active high input to reset FSM to the initial state A.
   - `s`: Input to control transitions between states A and B.
   - `w`: Input signal to be monitored over three clock cycles in states B, C, and D.

3. **Output:**
   - `z`: Output signal set to 1 if there are exactly two instances of w = 1 in the observed three clock cycles; otherwise, set to 0.

4. **Transitions and Actions:**
   - **State A**: 
     - `(s == 0)` -> Remain in State A.
     - `(s == 1)` -> Transition to State B.
   - **State B**: 
     - Count occurrences where `w == 1`.
     - Transition to State C regardless of w's value. Initialize counter.
   - **State C**: 
     - Count occurrences where `w == 1`.
     - Transition to State D regardless of w's value. Increment counter if `w == 1`.
   - **State D**: 
     - Count occurrences where `w == 1`.
     - Transition to State E regardless of w's value. Increment counter if `w == 1`.
   - **State E**: 
     - Set output `z = 1` if counter equals 2; otherwise, `z = 0`.
     - Transition back to State B to continue monitoring w for the next three clock cycles.
   
5. **Synchronous Reset:**
   - Upon `reset = 1`, the FSM transitions to State A and initializes all states and counters.

6. **Counter:**
   - A counter mechanism is to be included to count the instances of `w = 1` through states B, C, and D.

7. **Clock Cycle Handling:**
   - Each state (B, C, D) represents one clock cycle; transitions occur on each clock's rising edge.

This specification outlines five states to effectively implement the given FSM with the necessary transitions and logic to evaluate the input w over three clock cycles, controlling the output z accordingly.