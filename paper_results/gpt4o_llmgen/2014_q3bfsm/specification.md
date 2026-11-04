Technical Specification for Implementing the Finite-State Machine (FSM)

1. Overview:
   - Implement a finite-state machine (FSM) with synchronous active-high reset functionality.
   - The FSM has five states, represented by a 3-bit state register `y[2:0]`.
   - The FSM takes one input `x` and produces one output `z`.

2. State Encoding:
   - Present State: y[2:0]
     - State 000
     - State 001
     - State 010
     - State 011
     - State 100

3. State Transition Table:
   - | Present State | Next State (x=0) | Next State (x=1) | Output (z) |
     |---------------|------------------|------------------|------------|
     |      000      |        000       |        001       |     0      |
     |      001      |        001       |        100       |     0      |
     |      010      |        010       |        001       |     0      |
     |      011      |        001       |        010       |     1      |
     |      100      |        011       |        100       |     1      |

4. Inputs:
   - `clk`: Clock signal for sequential operation.
   - `reset`: Synchronous active-high reset to initialize the FSM to state 000.
   - `x`: Input signal to determine the next state transition.

5. Outputs:
   - `z`: Output signal determined by the current state.

6. FSM Implementation:
   - The FSM should be implemented using an always block, triggered by the rising edge of the clock (`clk`) and the reset (`reset`).
   - On reset, the FSM should transition to state 000.
   - Determine the next state based on the current state and input `x`.

7. Logic Description:
   - `always @(posedge clk or posedge reset)`:
     - If `reset` is high, set the current state to 000.
     - Otherwise, transition to the next state based on the present state and input `x`.

8. Register and Assignments:
   - Use a 3-bit register to hold the current state `y`.
   - Update output `z` based on the current state using combinational logic.

9. Testbench:
   - A testbench should be created to simulate the functionality of the FSM.
   - Verify state transitions and output logic based on different input combinations of `x` and reset conditions.

10. Constraints:
    - Use non-blocking assignments (`<=`) for sequential logic.
    - Adhere to synchronous design principles to ensure reliable FSM operation.