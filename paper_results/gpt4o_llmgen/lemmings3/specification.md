### Technical Specification for Lemming Finite State Machine

#### Overview:
Design a Moore state machine for Lemmings with the given states and transitions to realize the specified behavior in hardware. Utilize synchronous state transitions with asynchronous reset. The default state on reset is to walk left.

#### Inputs:
- `clk`: Clock signal for synchronous operations.
- `areset`: Asynchronous active-high reset signal.
- `bump_left`: Input indicating Lemming is bumped on the left side.
- `bump_right`: Input indicating Lemming is bumped on the right side.
- `ground`: Signal indicating if the ground is present (1) or absent (0).
- `dig`: Signal instructing Lemming to dig.

#### Outputs:
- `walk_left`: High when Lemming is in the "walking left" state.
- `walk_right`: High when Lemming is in the "walking right" state.
- `aaah`: High when Lemming is falling.
- `digging`: High when Lemming is digging.

#### States:
1. `WALK_LEFT`: Walking left on the ground.
2. `WALK_RIGHT`: Walking right on the ground.
3. `FALL_LEFT`: Falling with the intention to walk left after landing.
4. `FALL_RIGHT`: Falling with the intention to walk right after landing.
5. `DIG_LEFT`: Digging while initially walking left.
6. `DIG_RIGHT`: Digging while initially walking right.

#### State Transition Logic:
1. **Transition Conditions Prioritized**: 
   - **Fall**: Takes precedence over digging and direction switching.
   - **Dig**: Takes precedence over direction switching.
   - **Direction Change**: Happens if neither falling nor digging is occurring.

2. **State Transitions**:
   - **WALK_LEFT**: 
     - Transition to `FALL_LEFT` if `ground` is 0.
     - Transition to `DIG_LEFT` if `dig` is 1 and `ground` is 1.
     - Transition to `WALK_RIGHT` if `bump_left` is 1 and alone or `bump_right` is also 1.
   - **WALK_RIGHT**: 
     - Transition to `FALL_RIGHT` if `ground` is 0.
     - Transition to `DIG_RIGHT` if `dig` is 1 and `ground` is 1.
     - Transition to `WALK_LEFT` if `bump_right` is 1 and alone or `bump_left` is also 1.
   - **FALL_LEFT**: 
     - Transition to `WALK_LEFT` if `ground` is 1.
   - **FALL_RIGHT**: 
     - Transition to `WALK_RIGHT` if `ground` is 1.
   - **DIG_LEFT**: 
     - Transition to `FALL_LEFT` if `ground` becomes 0.
   - **DIG_RIGHT**: 
     - Transition to `FALL_RIGHT` if `ground` becomes 0.

3. **Initial State**:
   - Upon `areset`, the system initializes to `WALK_LEFT`.

#### Output Logic:
Outputs are determined by the current state as follows:
- `WALK_LEFT`: `walk_left = 1, walk_right = 0, aaah = 0, digging = 0`.
- `WALK_RIGHT`: `walk_left = 0, walk_right = 1, aaah = 0, digging = 0`.
- `FALL_LEFT`: `walk_left = 0, walk_right = 0, aaah = 1, digging = 0`.
- `FALL_RIGHT`: `walk_left = 0, walk_right = 0, aaah = 1, digging = 0`.
- `DIG_LEFT`: `walk_left = 0, walk_right = 0, aaah = 0, digging = 1`.
- `DIG_RIGHT`: `walk_left = 0, walk_right = 0, aaah = 0, digging = 1`.

#### Reset Behavior:
- On the rising edge of `areset`, asynchronously reset the machine to the initial `WALK_LEFT` state, setting outputs consistent with the state.

The above specification outlines the state machine for a Verilog implementation that meets the Lemming's required behaviors. Ensure the finite state machine is efficient with non-overlapping states and uses minimal additional logic.