# Web Research Results

Total Results: 1

## Result 1

A one-hot FSM is a state machine where each state is represented by a single bit in a state vector. In this encoding, the state vector has as many bits as there are states, and only one bit is set to '1' at any given time, indicating the current state. This approach avoids the need for state decoding logic, which can lead to faster operation.

When designing one-hot FSMs in Verilog, consider the following points:

*   **Encoding:** Use parameters to define state encodings instead of ``define`` macro definitions. In SystemVerilog, use enumerated types to define state encodings. Always define a parameter or enumerated type value for each state so you don't leave it to the synthesis tool to choose a value for you.
*   **Coding Style:** Use ``parallel_case`` and ``full_case`` directives on a ``case (1'b1)`` statement. Use ``state`` style to represent the current state.
*   **Assignments:** Assign the next state by: (1) a default assignment of 0 to the state vector; (2) fully specify all conditions of next state assignments, including staying in the current state.
*   **Combinational vs. Sequential Logic:** Code all sequential always blocks using nonblocking assignments (``<=``). Code all combinational always blocks using blocking assignments (=).
*   **Reverse Case Statement:** SystemVerilog and Verilog have a unique and efficient coding style for coding one-hot state machines, which uses a reverse case statement to test if a case item is true by using a case header of the form ``case (1'b1)``.
*   **Advantages:** One-hot encoding offers low switching activity, simplified encoding, and ease of design and debugging.
*   **Area and Speed:** One-hot state machines generally offer a speed advantage, trading off area. They are particularly suited to FPGAs.


---

