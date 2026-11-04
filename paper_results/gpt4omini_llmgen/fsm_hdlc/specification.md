### Technical Specification for Synchronous HDLC Framing FSM

#### Module Overview
This Verilog module implements a Moore finite state machine (FSM) for recognizing specific bit patterns in a continuous input bit stream related to HDLC framing: the flag sequence (`01111110`), the discard condition (`0111110`), and the error condition (`01111111...`). The system is clocked and synchronous with respect to a reset signal.

#### Inputs
- `clk`: Clock input for synchronizing state transitions.
- `reset`: Synchronous reset signal, active high. Resets the FSM to an initial state.
- `in`: Continuous input bit stream (1-bit wide).

#### Outputs
- `disc`: Asserted high for one clock cycle when the "discard" condition (`0111110`) is detected.
- `flag`: Asserted high for one clock cycle when a "flag" (`01111110`) is detected.
- `err`: Asserted high for one clock cycle when 7 or more consecutive 1s are detected.

#### State Definition
The FSM will include the following states:
1. `S0`: Initial state, waiting for input.
2. `S1`: One `1` received.
3. `S2`: Two consecutive `1`s received.
4. `S3`: Three consecutive `1`s received.
5. `S4`: Four consecutive `1`s received.
6. `S5`: Five consecutive `1`s received.
7. `S6`: Six consecutive `1`s received.
8. `Serr`: Error state for detecting 7 or more consecutive `1`s.
9. `Sdisc`: Discard state for the `0111110` pattern.

#### State Transitions
- From `S0`: 
  - On `in=0`, remain in `S0`.
  - On `in=1`, transition to `S1`.
  
- From `S1`: 
  - On `in=0`, transition to `S0`.
  - On `in=1`, transition to `S2`.
  
- From `S2`: 
  - On `in=0`, transition to `S0`.
  - On `in=1`, transition to `S3`.
  
- From `S3`: 
  - On `in=0`, transition to `S0`.
  - On `in=1`, transition to `S4`.

- From `S4`: 
  - On `in=0`, transition to `S0`.
  - On `in=1`, transition to `S5`.

- From `S5`: 
  - On `in=0`, transition to `S0`.
  - On `in=1`, transition to `S6`.

- From `S6`: 
  - On `in=0`, transition to `S0` (flag detected on cycle); assert `flag`.
  - On `in=1`, transition to `Serr` (error detected); assert `err`.

- From `Serr`: 
  - On `in=0` or `in=1`, remain in `Serr` (stay in error state).

#### Reset Logic
On receiving the `reset` signal:
- The FSM should reset to state `S0`, clearing all output flags (`disc`, `flag`, `err`).

#### Output Logic
The output flags will be asserted following the Moore model:
- `disc` will be high in the cycle after a `0111110` condition is met.
- `flag` will be high in the cycle after a `01111110` condition is met.
- `err` will be high in the cycle after detecting 7 or more consecutive `1`s.

### Implementation Notes
- Ensure proper clock edge detection for synchronous operation.
- Use non-blocking assignments within the `always @(posedge clk or posedge reset)` block.
- Outputs should be driven consistent with Moore FSM principles, allowing for stable output through complete clock cycles.
- Testbench should be implemented to verify the FSM behavior with various input sequences. 

This specification provides a detailed outline for implementing the desired functionality in Verilog.