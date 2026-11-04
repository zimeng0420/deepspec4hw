## Technical Specification for Lemming Finite State Machine

### Module: `top_module`

#### Ports:
- **Inputs:**
  - `clk`: Clock input, used to synchronize the state transitions.
  - `areset`: Asynchronous reset input, positive edge triggered, resets the Lemming to walk left.
  - `bump_left`: Input indicating a bump on the left side.
  - `bump_right`: Input indicating a bump on the right side.

- **Outputs:**
  - `walk_left`: Output signal, high when the Lemming is in the state of walking left.
  - `walk_right`: Output signal, high when the Lemming is in the state of walking right.

#### Internal Logic:
1. **State Encoding:**
   - `STATE_LEFT`: 0 - Represents the state where the Lemming is walking left.
   - `STATE_RIGHT`: 1 - Represents the state where the Lemming is walking right.

2. **State Transition Diagram:**
   - **Initial State on Reset:**
     - When `areset` is high, transition to `STATE_LEFT`.
   - **State Transitions:**
     - From `STATE_LEFT`:
       - If either `bump_left` or `bump_right` is 1, transition to `STATE_RIGHT`.
       - Otherwise, stay in `STATE_LEFT`.
     - From `STATE_RIGHT`:
       - If either `bump_left` or `bump_right` is 1, transition to `STATE_LEFT`.
       - Otherwise, stay in `STATE_RIGHT`.

3. **Output Logic (Moore Machine):**
   - `walk_left` is high when in `STATE_LEFT`.
   - `walk_right` is high when in `STATE_RIGHT`.

#### Additional Constraints:
- Ensure the asynchronous nature of `areset`, which must take precedence over synchronous state changes triggered by `clk`.
- The transitions should occur on the rising edge of the `clk` unless overruled by `areset`.

#### Implementation Consideration:
- Use non-blocking assignments for state changes to ensure proper synchronization in a sequential logic circuit.
- Ensure that the design is fully synchronous with respect to the clock, apart from the asynchronous reset.

This specification provides structural guidelines for implementing the behavior of the Lemming in its simplified 2D world using a Moore finite state machine model.