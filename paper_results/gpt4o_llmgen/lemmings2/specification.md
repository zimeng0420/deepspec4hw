### Technical Specification for Lemming State Machine

#### Inputs:
- `clk`: Clock signal input used for synchronizing state transitions.
- `areset`: Asynchronous reset signal, active high, sets the Lemming to "walking left" state.
- `bump_left`: Input signal that represents an obstacle on the left side of the Lemming, active high.
- `bump_right`: Input signal that represents an obstacle on the right side of the Lemming, active high.
- `ground`: Input signal indicating ground presence (1 = ground present, 0 = ground absent).

#### Outputs:
- `walk_left`: Output signal, active high, indicating the Lemming is walking left.
- `walk_right`: Output signal, active high, indicating the Lemming is walking right.
- `aaah`: Output signal, active high, indicating the Lemming is falling.

#### States:
1. **STATE_WALK_LEFT**: Initial state after reset or when walking left.
   - `walk_left = 1`, `walk_right = 0`, `aaah = 0`
2. **STATE_WALK_RIGHT**: State when the Lemming is walking right.
   - `walk_left = 0`, `walk_right = 1`, `aaah = 0`
3. **STATE_FALL_LEFT**: State when the Lemming is falling and was previously moving left.
   - `walk_left = 0`, `walk_right = 0`, `aaah = 1`
4. **STATE_FALL_RIGHT**: State when the Lemming is falling and was previously moving right.
   - `walk_left = 0`, `walk_right = 0`, `aaah = 1`

#### State Transition Logic:
- **Reset Condition (`areset = 1`)**:
  - Transition to **STATE_WALK_LEFT** regardless of current state.

- **Normal Operation (`areset = 0`)**:
  - **From STATE_WALK_LEFT**:
    - If `ground = 0`: Transition to **STATE_FALL_LEFT**.
    - If `bump_left = 1` or (`bump_left = 1` and `bump_right = 1`): Transition to **STATE_WALK_RIGHT**.
  - **From STATE_WALK_RIGHT**:
    - If `ground = 0`: Transition to **STATE_FALL_RIGHT**.
    - If `bump_right = 1` or (`bump_left = 1` and `bump_right = 1`): Transition to **STATE_WALK_LEFT**.
  - **From STATE_FALL_LEFT**:
    - If `ground = 1`: Transition to **STATE_WALK_LEFT**.
  - **From STATE_FALL_RIGHT**:
    - If `ground = 1`: Transition to **STATE_WALK_RIGHT**.

#### Implementation Notes:
- The state machine should be implemented as a Moore machine, where the outputs depend only on the current state.
- The Lemming retains its walking direction when transitioning out of a fall, regardless of bump signals during the fall or on the same cycle as ground reappears.
- Asynchronous reset has the highest priority and will always force the FSM into the **STATE_WALK_LEFT** whenever active.

#### Assumptions:
- The inputs and outputs are active high.
- The environment ensures glitch-free input signals, particularly the `areset` for consistent asynchronous control.

This specification outlines the behavior and design of a Moore finite state machine for modeling the Lemming's movements and interactions based on the provided inputs and expected outputs.