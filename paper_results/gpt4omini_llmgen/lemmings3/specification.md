### Technical Specifications for the Lemmings State Machine Module

#### Module Definition
```verilog
module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);
```

#### State Definitions
Define the states for the finite state machine (FSM):
- **WALK_LEFT** (00): Walking left
- **WALK_RIGHT** (01): Walking right
- **FALLING** (10): Falling state (ground = 0)
- **DIGGING** (11): Digging state

#### State Encoding
Use a 2-bit encoding for the four states:
- 00: WALK_LEFT
- 01: WALK_RIGHT
- 10: FALLING
- 11: DIGGING

#### State Transition Conditions
1. **From WALK_LEFT:**
    - If `ground == 0`, transition to FALLING.
    - If `bump_right` is 1, transition to WALK_RIGHT.
    - If `dig` is 1 and `ground == 1`, transition to DIGGING.

2. **From WALK_RIGHT:**
    - If `ground == 0`, transition to FALLING.
    - If `bump_left` is 1, transition to WALK_LEFT.
    - If `dig` is 1 and `ground == 1`, transition to DIGGING.

3. **From FALLING:**
    - If `ground == 1`, transition back to WALK_LEFT or WALK_RIGHT based on previously walking direction.

4. **From DIGGING:**
    - If `ground == 0`, transition to FALLING.
    - Cannot switch direction or fall during this state.

#### Output Logic
1. **Walking Outputs:**
    - `walk_left` = 1 when in WALK_LEFT state.
    - `walk_right` = 1 when in WALK_RIGHT state.
   
2. **Falling Output:**
    - `aaah` = 1 when in FALLING state.
   
3. **Digging Output:**
    - `digging` = 1 when in DIGGING state.

#### Reset Behavior
- On asynchronous reset `areset`, the FSM should transition to the initial state (WALK_LEFT). The outputs should be set accordingly.

#### Clock Cycle Behavior
- Use a positive edge-triggered clock to handle state transitions. The state of the FSM should be updated at every rising edge of the clock.

#### Design Constraints
- The FSM should handle multiple conditions, ensuring proper precedence: falling > digging > changing directions.
- Ensure no glitches occur on the outputs during transitions.

#### Implementation Guidelines
- A case statement can be utilized to describe the state transitions based on the current state and input signals.
- Always block can be used to update the state on each clock cycle.
- The outputs should be updated based on the current state in a combinational block.

### Example Output Structure
```verilog
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Reset state and outputs
        current_state <= WALK_LEFT; 
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
        digging <= 0;
    end else begin
        // Next state logic
        case (current_state)
            WALK_LEFT: /* state transition logic */
            WALK_RIGHT: /* state transition logic */
            FALLING: /* state transition logic */
            DIGGING: /* state transition logic */
        endcase
    end
end

always @(*) begin
    // Output logic based on current state
end
```

This specification provides a comprehensive outline for implementing the Lemmings FSM in Verilog.