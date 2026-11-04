### Technical Specification for Finite State Machine (FSM) to Detect Message Boundaries

#### Inputs:
- **clk**: Clock signal for synchronous operation.
- **in**: 8-bit input byte stream (in[7:0]).
- **reset**: Active-high synchronous reset signal.

#### Outputs:
- **out_bytes**: 24-bit output representing the received message (3 bytes).
  - **out_bytes[23:16]**: First byte.
  - **out_bytes[15:8]**: Second byte.
  - **out_bytes[7:0]**: Third byte.
- **done**: Signal indicating that a complete message has been successfully received (asserted high one clock cycle after the third byte is received).

#### State Definitions:
1. **IDLE**: Wait for a byte with `in[3] = 1` to begin message reception.
2. **BYTE1**: The first byte of the message has been received.
3. **BYTE2**: The second byte of the message has been received.
4. **BYTE3**: The third byte of the message has been received, assert the `done` signal on the next clock cycle.

#### Behavior:
- The FSM begins in the **IDLE** state.
- In the **IDLE** state:
  - Continuously monitor the input.
  - Discard bytes until it sees `in[3] = 1`.
- Transition to **BYTE1** when the first byte is received.
- Transition to **BYTE2** when the second byte is received (after `BYTE1`).
- Transition to **BYTE3** when the third byte is received (after `BYTE2`).
- In **BYTE3**, assert the `done` signal on the next clock cycle, then return to **IDLE**.

#### Output Logic:
- **out_bytes** should hold the valid 24-bit message only when `done` is asserted.
- In states other than **BYTE3**, **out_bytes** can be in a don't-care state (can hold any value).

#### Reset Behavior:
- When the `reset` signal is asserted, the FSM should:
  - Clear `out_bytes`.
  - Return to the **IDLE** state.

#### Timing:
- The output `out_bytes` must be stable and valid in the same cycle that `done` is asserted.
- Timing must ensure that each state transition occurs with respect to the clock edge.

### Example State Transition Table:

| Current State | Input Condition       | Next State | Action                         |
|----------------|----------------------|-------------|--------------------------------|
| IDLE           | `in[3] = 1`          | BYTE1      | Store byte to `out_bytes[23:16]` |
| BYTE1         | Any                   | BYTE2      | Store byte to `out_bytes[15:8]`  |
| BYTE2         | Any                   | BYTE3      | Store byte to `out_bytes[7:0]`   |
| BYTE3         | Any                   | IDLE        | Assert `done` on next clock cycle |

### Finite State Machine Implementation:
- The FSM will be designed using a combination of registers for state storage and logic to interpret input and manage the transitions appropriately.
- A 2-bit state register can be used to encode the four states. 

This specification serves as an outline for implementing the described FSM in Verilog.