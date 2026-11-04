# Web Research Results

Total Results: 1

## Result 1

The game "Lemmings" involves creatures with simple behaviors that can be modeled using a finite state machine (FSM). In this model, a Lemming can be in one of two states: walking left or walking right.

**Core Concepts:**

*   **States:** The Lemming exists in a limited number of states, such as walking left, walking right, falling, digging, or being idle.
*   **Transitions:** The Lemming changes states based on certain conditions or inputs.
*   **Inputs:** These include sensors for obstacles (bump_left, bump_right), ground detection (ground), and instructions to dig (dig).
*   **Outputs:** These control the Lemming's actions (walk_left, walk_right, aaah, digging).

**Behavioral Rules and Finite State Machine Implementation:**

*   **Walking and Direction Changes:**
    *   The Lemming walks either left or right.
    *   If a Lemming encounters an obstacle on its left (bump_left = 1), it switches to walking right.
    *   If it encounters an obstacle on its right (bump_right = 1), it switches to walking left.
    *   If bumped on both sides, it still switches direction.
*   **Falling:**
    *   If the ground disappears (ground = 0), the Lemming starts to fall and emits a "aaah!" sound.
    *   While falling, being bumped does not change the walking direction.
    *   The Lemming continues to fall until ground reappears (ground = 1), resuming its previous walking direction.
*   **Digging:**
    *   If the dig signal is active (dig = 1) and the Lemming is on the ground (ground = 1) and not falling, it starts digging.
    *   The Lemming continues digging until it reaches the other side (ground = 0), at which point it falls.
    *   Being bumped while digging has no effect.
    *   The dig instruction is ignored if the Lemming is falling or there is no ground.
*   **Precedence:** If multiple conditions are met, the actions are prioritized as follows: falling > digging > switching directions.
*   **Splattering:** If a Lemming falls for too long (e.g., more than 20 clock cycles) and then hits the ground, it splatters and all outputs (walking, falling, digging) become 0 until a reset occurs.

**Verilog Implementation:**

The Lemmings game can be implemented using Verilog, a hardware description language, to model the behavior of the creatures. A Moore state machine can be used, where the outputs depend only on the current state.

**Module Definition:**

The Verilog code typically includes:

*   **Inputs:** `clk` (clock), `areset` (asynchronous reset), `bump_left`, `bump_right`, `ground`, `dig`.
*   **Outputs:** `walk_left`, `walk_right`, `aaah`, `digging`.
*   **States:** Defined using parameters (e.g., `LEFT`, `RIGHT`).
*   **Registers:** To store the current state and the next state.
*   **Combinational Logic:** An `always @(*)` block to define the next state based on the current state and inputs.
*   **Sequential Logic:** An `always @(posedge clk, posedge areset)` block to update the current state on each clock cycle, with an asynchronous reset.
*   **Output Logic:** Assign statements to determine the output signals based on the current state.


---

