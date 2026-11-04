# Web Research Results

Total Results: 1

## Result 1

The following information pertains to the prioritization of actions in a Finite State Machine (FSM) for a Lemmings game, specifically focusing on the actions of "fall," "dig," and "direction change."

**Concept Definitions**

*   **Finite State Machine (FSM):** A mathematical model used to design algorithms and digital logic circuits. It consists of a finite number of states, transitions between those states, and actions.
*   **States:** Represent a condition or situation.
*   **Transitions:** Dictate how the system moves from one state to another in response to inputs or events.
*   **Actions:** May occur during transitions or upon entering a particular state.
*   **Moore Machine:** The output depends only on the present state.
*   **Mealy Machine:** The output depends on both the current state and the inputs.

**Working Principles**

*   An FSM transitions between states based on inputs and clock signals.
*   The FSM has three main parts: state register, next state logic, and output logic.
*   The state register holds the current state and updates on clock edges.
*   Next state logic determines the next state based on the current state and inputs.
*   Output logic generates outputs depending on the current state (Moore machine) or current state and inputs (Mealy machine).
*   In a synchronous FSM, the transition is controlled by a clock signal and can occur only at the triggering edge of the clock.

**Design Methods**

*   **State Diagram:** A graphical representation of the FSM, showing states as nodes and transitions as arrows.
*   **State Transition Table:** Lists all flip-flops in the FSM and any dependent inputs on the left side of the table, and the flip-flop configuration and the flip-flop bits representing the next state and any outputs on the right.
*   **Verilog Implementation:** FSMs can be implemented in Verilog using two `always` blocks: one for the sequential state register and one for the combinational next-state and output logic.
*   **Moore vs. Mealy:** The choice between Moore and Mealy machines depends on design requirements for output timing and complexity.

**Best Practices**

*   **States:** Represent states using parameters or `localparam` for readability and maintainability.
*   **Synchronous Reset:** Use a synchronous reset to reset the FSM to a known initial state on a clock edge.
*   **Combinational Next State Logic:** Implement next state logic with a `case` statement.
*   **Output Logic:** Output logic can be inside the next state block or a separate block depending on Moore or Mealy FSM style.
*   **Two Always Block FSM Style:** One of the best Verilog coding styles is to code the FSM design using two `always` blocks, one for the sequential state register and one for the combinational next-state and combinational output logic.
*   **Default Assignments:** Placing a default next state assignment on the line immediately following the `always` block sensitivity list is a very efficient coding style.

**Lemmings Game Specifics**

*   **Actions and Prioritization:** In the Lemmings game, the actions "fall," "dig," and "direction change" need to be prioritized. If more than one condition is satisfied, "fall" has higher precedence than "dig," which has higher precedence than switching directions.
*   **States:** The Lemmings can be in states such as walking left, walking right, falling, and digging.
*   **Transitions:** Transitions between states are triggered by events such as hitting an obstacle (direction change), ground disappearing (fall), ground reappearing (resume walking), and being told to dig.
*   **Falling:** When the ground is 0, the Lemming will fall and say "aaah!". Being bumped while falling does not affect the walking direction.
*   **Digging:** A Lemming can dig if it is currently walking on ground (ground=1 and not falling). Being bumped while digging has no effect.
*   **Splatter:** If a Lemming falls for more than 20 clock cycles then hits the ground, it will splatter and cease walking, falling, or digging.


---

