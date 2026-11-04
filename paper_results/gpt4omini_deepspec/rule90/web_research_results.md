# Web Research Results

Total Results: 1

## Result 1

Rule 90 is a one-dimensional cellular automaton where the next state of a cell is determined by the XOR function of its two neighbors. It consists of a one-dimensional array of cells, each holding a binary value (0 or 1). At each time step, all cells are updated simultaneously.

Here's a breakdown of its fundamental properties and behaviors:

*   **Basic Rule:** The new value of a cell is the exclusive OR (XOR) of its left and right neighbors from the previous time step.

    *   Left | Center | Right | Center's next state
        ------- | -------- | -------- | ---------------------
        1 | 1 | 1 | 0
        1 | 1 | 0 | 1
        1 | 0 | 1 | 0
        1 | 0 | 0 | 1
        0 | 1 | 1 | 1
        0 | 1 | 0 | 0
        0 | 0 | 1 | 1
        0 | 0 | 0 | 0
*   **Elementary Cellular Automaton:** Rule 90 is classified as an elementary cellular automaton because it operates on a 1D grid with binary values, and its rule depends only on the immediate neighbors.
*   **Additive Cellular Automaton:** Rule 90 is an additive cellular automaton, meaning that the superposition of two initial states will result in the superposition of their individual evolutions. This is due to its relation with mod 2.
*   **Time-Space Diagram:** When Rule 90 is initiated from a single live cell, it generates a time-space diagram resembling a Sierpiński triangle.
*   **Reversibility:** Rule 90 is not reversible with periodic boundary conditions. However, with null boundary conditions, it is reversible when the number of cells is even.
*   **Boundary Conditions:** The behavior of Rule 90 can be influenced by the boundary conditions applied to the array of cells. Common boundary conditions include:

    *   **Null Boundary Conditions:** Boundaries (q[-1] and q) are both zero (off).
    *   **Periodic Boundary Conditions:** The edges of the grid are connected, forming a loop.
*   **Applications:** Rule 90 has found applications in various fields, including:

    *   Pseudorandom number generation.
    *   Test pattern generation for built-in self-test (BIST) in integrated circuits.
    *   Design of cryptographic protocols.



---

