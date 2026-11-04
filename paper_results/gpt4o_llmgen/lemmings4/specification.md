**Technical Specification for Lemmings Finite State Machine (FSM) Design:**

**1. Inputs:**
   - `clk`: Clock signal, positive edge-triggered.
   - `areset`: Asynchronous reset, active high to reset the FSM to its initial state.
   - `bump_left`: Signal indicating a bump on the left.
   - `bump_right`: Signal indicating a bump on the right.
   - `ground`: Signal indicating presence of ground (`1` for ground present, `0` for no ground, i.e., falling).
   - `dig`: Signal indicating a command to start digging.

**2. Outputs:**
   - `walk_left`: Indicates Lemming is walking to the left (active high).
   - `walk_right`: Indicates Lemming is walking to the right (active high).
   - `aaah`: Indicates Lemming is in a falling state (active high).
   - `digging`: Indicates Lemming is in a digging state (active high).

**3. State Encoding:**
   - `State_WalkLeft`: Lemming walking left on ground.
   - `State_WalkRight`: Lemming walking right on ground.
   - `State_FallLeft`: Lemming falling, was walking left.
   - `State_FallRight`: Lemming falling, was walking right.
   - `State_DigLeft`: Lemming digging, was walking left.
   - `State_DigRight`: Lemming digging, was walking right.
   - `State_Splatter`: Lemming has splattered after a long fall.

**4. State Transitions:**
   - **From `State_WalkLeft`:**
     - Transition to `State_WalkRight` on `bump_left` or both `bump_left` and `bump_right`.
     - Transition to `State_FallLeft` on `ground=0`.
     - Transition to `State_DigLeft` on `dig=1` and `ground=1`.

   - **From `State_WalkRight`:**
     - Transition to `State_WalkLeft` on `bump_right` or both `bump_left` and `bump_right`.
     - Transition to `State_FallRight` on `ground=0`.
     - Transition to `State_DigRight` on `dig=1` and `ground=1`.

   - **From `State_FallLeft` & `State_FallRight`:**
     - Transition to `State_WalkLeft` on `ground=1` and original direction was left and fall duration <= 20 cycles; if fall duration > 20, transition to `State_Splatter`.
     - Transition to `State_WalkRight` on `ground=1` and original direction was right and fall duration <= 20 cycles; if fall duration > 20, transition to `State_Splatter`.

   - **From `State_DigLeft` & `State_DigRight`:**
     - Transition to `State_FallLeft` or `State_FallRight` on `ground=0`, keeping the original walking direction when hitting ground again.

   - **From `State_Splatter`:**
     - Remain in `State_Splatter` until `areset` is triggered.

**5. Additional Functionality:**
   - Fall duration counter to measure fall length in clock cycles. Reset the counter when on `ground`.
   - Fall counter incremented each clock cycle while in `State_FallLeft` or `State_FallRight`. Upon hitting ground, check counter to decide transition to `State_Splatter` or resumption of walking state.

**6. Design Constraints:**
   - Priority handling: Falling (`ground=0`) takes precedence over digging (`dig=1`), which takes precedence over direction switching due to `bump_left` or `bump_right`.
   - `areset`: Must reset FSM to `State_WalkLeft` immediately regardless of current state.

**7. Default Output Logic for Each State:**
   - `State_WalkLeft`: `walk_left=1`, `walk_right=0`, `aaah=0`, `digging=0`.
   - `State_WalkRight`: `walk_left=0`, `walk_right=1`, `aaah=0`, `digging=0`.
   - `State_FallLeft`/`State_FallRight`: `walk_left=0`, `walk_right=0`, `aaah=1`, `digging=0`.
   - `State_DigLeft`: `walk_left=1`, `walk_right=0`, `aaah=0`, `digging=1`.
   - `State_DigRight`: `walk_left=0`, `walk_right=1`, `aaah=0`, `digging=1`.
   - `State_Splatter`: `walk_left=0`, `walk_right=0`, `aaah=0`, `digging=0`.

This technical specification outlines the necessary components and behavior patterns for the Lemmings FSM, ensuring it accurately reflects the described Lemming behavior in the game context.