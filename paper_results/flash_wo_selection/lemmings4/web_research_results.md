# Web Research Results

Total Results: 1

## Result 1

The game Lemmings uses a finite state machine to model the behavior of the critters in the game. Each Lemming can be in one of two states: walking left or walking right.

**Core Concepts:**

*   **States:** Lemmings exist in distinct states, such as walking left or walking right.
*   **Transitions:** Lemmings change states based on inputs, like bumping into obstacles.
*   **Inputs:** These include `bump_left`, `bump_right`, `ground`, and `dig`.
*   **Outputs:** The FSM controls outputs such as `walk_left`, `walk_right`, `aaah` (falling), and `digging`.
*   **Moore Machine:** The lemming's behavior can be implemented using a Moore state machine. In a Moore FSM, the output depends only on the current state, not the input.

**Lemming Actions and State Transitions:**

*   **Walking and Bumping:** Lemmings walk either left or right. If a Lemming walking left is bumped (bump\_left = 1), it switches to walking right, and vice versa. Bumping on both sides simultaneously also causes a direction switch.
*   **Falling:** When the ground disappears (ground = 0), the Lemming falls and outputs "aaah!". It resumes walking in the same direction when the ground reappears (ground = 1). Bumping while falling does not change the walking direction.
*   **Digging:** If a Lemming is on the ground (ground = 1) and receives the dig signal (dig = 1), it starts digging. It continues digging until it is no longer on the ground (ground = 0), at which point it falls. Bumping into something while digging does not affect the digging action.
*   **Splattering:** If a Lemming falls for more than 20 clock cycles and then hits the ground, it splatters. When a Lemming splatters, it stops walking, falling, or digging, and all outputs become 0 until the FSM is reset. Splattering only occurs upon hitting the ground, not in mid-air.
*   **Reset:** A reset signal (`areset`) asynchronously resets the Lemming to the walk-left state.

**Verilog Implementation Details:**

*   The FSM can be implemented in Verilog using registers for the current state and next state.
*   An `always` block is used to define the state transition logic based on the inputs and current state.
*   Another `always` block is used to update the state register on each clock cycle, with an asynchronous reset.
*   Output logic is implemented using `assign` statements based on the current state.

**Additional Considerations:**

*   Finite state machines are useful for managing different states within a game or software. They can help organize control flow, simplify debugging, and make the codebase more scalable.
*   When designing states, it's important to keep them simple and focused on a specific behavior. If a state becomes too complex, consider breaking it down into smaller states.
*   Events can be used to trigger transitions, making it easier to manage the game's behavior.


---

