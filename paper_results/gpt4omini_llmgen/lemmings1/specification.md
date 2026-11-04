Here is the technical specification for the Lemming's behavior using a Moore state machine:

### Module Specification: Lemming FSM

**Module Name:** `top_module`

**Inputs:**
- `input clk`: Clock signal for state transitions (active on rising edge).
- `input areset`: Asynchronous reset signal (active high) that initializes the FSM to the "walk left" state.
- `input bump_left`: Indicates a bump on the left side (active high).
- `input bump_right`: Indicates a bump on the right side (active high).

**Outputs:**
- `output walk_left`: Active high signal indicating the Lemming is walking left.
- `output walk_right`: Active high signal indicating the Lemming is walking right.

### Internal States:
1. **State 0 (Walking Left):**
   - **Output:** `walk_left = 1`, `walk_right = 0`
   - **Next State Logic:**
     - If `bump_left = 1`: Transition to State 1 (Walking Right)
     - If `bump_right = 1`: Transition to State 1 (Walking Right)
     - If both `bump_left = 1` and `bump_right = 1`: Transition to State 1 (Walking Right)

2. **State 1 (Walking Right):**
   - **Output:** `walk_left = 0`, `walk_right = 1`
   - **Next State Logic:**
     - If `bump_left = 1`: Transition to State 0 (Walking Left)
     - If `bump_right = 1`: Transition to State 0 (Walking Left)
     - If both `bump_left = 1` and `bump_right = 1`: Transition to State 0 (Walking Left)

### State Transition Diagram:
```
     +-------------------+      bump_left/bump_right 
     |   Walking Left    | <--------------------+
     | (State 0)        |                     +
     +-------------------+                     |
            ^  |                               |
            |  |                               |
            |  |                               |
     bump_right/bump_left                   +
            |  |                               |
            |  +-------------------+            |
        +-------------------+     +-------------+
        |   Walking Right    | <---+
        | (State 1)        |        
        +-------------------+
```

### Description:
- The FSM initializes to the state of walking left when `areset` is asserted.
- Upon receiving a bump signal from either side (`bump_left` or `bump_right`), the FSM transitions to the opposite state.
- The outputs `walk_left` and `walk_right` signify which direction the Lemming is walking based on the current state.

### Implementation Notes:
- The FSM must use combinational logic for the state transition and output logic, driven by the inputs.
- The state will only change on the rising edge of `clk` unless reset by `areset`.

This specification should be utilized to implement the Verilog code for the Lemming FSM.