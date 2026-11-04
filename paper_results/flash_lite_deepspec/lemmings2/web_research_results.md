# Web Research Results

Total Results: 1

## Result 1

The following information pertains to the technical term "State transition logic for walking left/right and falling in a Lemmings FSM":

*   **Lemmings Game Mechanics and FSM Implementation:**
    *   The game Lemmings involves critters with simple behaviors that can be modeled using a Finite State Machine (FSM).
    *   In a 2D Lemmings world, a Lemming can be in states like walking left or right.
    *   The Lemming changes direction when it encounters an obstacle.
    *   If a Lemming is bumped on the left, it walks right, and if bumped on the right, it walks left.
    *   If bumped on both sides simultaneously, the Lemming still switches directions.
    *   When ground=0, the Lemming falls and says "aaah!". When the ground reappears (ground=1), the Lemming resumes walking in the same direction as before the fall.
    *   Being bumped while falling does not affect the walking direction.
    *   Being bumped in the same cycle as ground disappears or reappears while still falling also does not affect the walking direction.
    *   The "aaah!" scream of the falling Lemming can be represented as an output state.
    *   A Lemming can dig if it is walking on the ground (ground=1 and not falling).
    *   A Lemming will continue digging until it reaches the other side (ground=0).
    *   If more than one condition (falling, digging, or switching directions) is satisfied, fall has the highest precedence, followed by dig, and then switching directions.

*   **Moore Machine Implementation:**
    *   The behavior of the Lemmings can be modeled using a Moore state machine.
    *   In a Moore machine, the output depends only on the present state.

*   **Verilog Implementation:**
    *   The Lemmings game logic can be implemented using Verilog.
    *   The module declaration includes inputs for clock (clk), asynchronous reset (areset), bump\_left, bump\_right, and ground.
    *   Outputs include walk\_left, walk\_right, and aaah.
    *   Parameters can be defined for states like LEFT and RIGHT.
    *   A `reg` type variable is used for the state and next\_state.
    *   The state transition logic is implemented using an `always @(*)` block with a `case` statement to determine the next state based on the current state and inputs.
    *   State flip-flops with asynchronous reset are implemented using an `always @(posedge clk, posedge areset)` block.
    *   Output logic assigns values to walk\_left and walk\_right based on the current state.



---

