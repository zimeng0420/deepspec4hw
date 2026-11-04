Technical Specification for UART Byte Receiver FSM

1. **Inputs and Outputs:**
   - `clk`: Clock signal to synchronize state machine operations.
   - `in`: Serial data input line.
   - `reset`: Active-high synchronous reset input.
   - `out_byte`: 8-bit output line to hold successfully received data bytes.
   - `done`: Output signal that asserts high to indicate the correct reception and validation of a data byte.

2. **States:**
   - `IDLE`: Initial state waiting for the start bit (logic 0).
   - `START`: State upon detecting the start bit, preparing to receive and validate each data bit.
   - `RECEIVE_D0` to `RECEIVE_D7`: Intermediate states for each data bit being received (total of 8 states, one for each data bit).
   - `STOP`: State to validate the stop bit (logic 1).
   - `ERROR`: State when an incorrect stop bit is detected, waits for a new start bit.

3. **Transition Conditions:**
   - Transition from `IDLE` to `START` on detecting a logic 0 (start bit).
   - Sequential transitions from `START` through `RECEIVE_D0` to `RECEIVE_D7` upon capturing each data bit at the input.
   - Transition from `RECEIVE_D7` to `STOP` after capturing the 8th data bit.
   - Transition from `STOP` to `IDLE` if stop bit is correct (logic 1).
   - Transition from `STOP` to `ERROR` if the stop bit is incorrect.
   - Transition from `ERROR` to `IDLE` upon detecting a stop bit, in readiness for the next start bit.

4. **Operations:**
   - In `START` and each `RECEIVE_Dx` state, capture the respective bit from the `in` line and store it in the `out_byte` register.
   - Validate stop bit at `STOP` state, assert `done` if validation is successful.
   - If in `ERROR`, ignore all bits except when detecting a correct stop bit.

5. **Reset Behavior:**
   - On `reset`, the state machine transitions to `IDLE` state, and `out_byte` is reset to a default value (e.g., 8'd0).

6. **Clock Edge Sensitivity:**
   - The FSM transitions on the rising edge of the `clk` signal.

7. **Synchronous Behavior:**
   - The reset signal (`reset`) is synchronous with the clock.

This FSM design ensures that only correctly framed bytes (start bit, 8 data bits, stop bit) result in a `done` assertion and a valid `out_byte`. The `ERROR` state provides robustness against protocol violations by avoiding false state transitions until a valid stop condition is detected.