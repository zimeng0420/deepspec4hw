## Technical Specification for FSM to Detect Sequence 1101

### Module Description
A finite-state machine (FSM) is designed to detect the sequence "1101" in a serial input bit stream. Once the sequence is detected, the output signal `start_shifting` is set to '1' indefinitely, or until the FSM is reset. The reset is active-high and synchronous to the clock.

### Inputs
- `clk`: Clock input for synchronous operations.
- `reset`: Active-high synchronous reset input signal. When `reset` is high, the FSM will reset to its initial state.
- `data`: Serial input data bit. This is the input stream where the FSM searches for the sequence "1101".

### Outputs
- `start_shifting`: Output signal that is set to '1' indefinitely after the sequence "1101" is detected. This remains '1' until the FSM is reset.

### State Encoding
The FSM will have the following states to track the sequence "1101":
1. `IDLE` (Initial State): Waiting for the first '1'.
2. `S1`: Detected the first '1'.
3. `S11`: Detected the sequence "11".
4. `S110`: Detected the sequence "110".
5. `DETECT`: Detected the sequence "1101". Transition to this state will set `start_shifting` to '1'.

### State Transition
- From `IDLE`:
  - On `data = 1`: Transition to `S1`.
  - On `data = 0`: Stay in `IDLE`.
- From `S1`:
  - On `data = 1`: Transition to `S11`.
  - On `data = 0`: Stay in `IDLE`.
- From `S11`:
  - On `data = 1`: Stay in `S11`.
  - On `data = 0`: Transition to `S110`.
- From `S110`:
  - On `data = 1`: Transition to `DETECT`.
  - On `data = 0`: Stay in `IDLE`.
- From `DETECT` (final state):
  - The output `start_shifting` is set to '1'.
  - On `reset`: Transition back to `IDLE`.

### Output Logic
- `start_shifting` is set to '1' when the FSM reaches the `DETECT` state.
- The output remains '1' until a reset event occurs.

### Reset Logic
- The FSM is reset to the `IDLE` state on an active-high `reset` signal. The `start_shifting` output is also reset to '0' on reset.

### Timing Specification
- The FSM transitions states on the rising edge of `clk`.
- The reset should be synchronous with the `clk`.

### Assumptions
- The input stream is continuous and might contain arbitrary data sequences.
- The clock frequency and reset pulse width are sufficient to perform synchronous operations with the FSM logic.

The above specification is designed for efficient hardware implementation using Verilog in combinational and sequential logic blocks to realize the FSM behavior.