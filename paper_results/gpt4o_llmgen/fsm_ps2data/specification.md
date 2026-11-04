# Technical Specification for Finite State Machine (FSM) to Detect Message Boundaries

## Objective

Develop a Verilog module named `top_module` that implements a finite state machine to detect message boundaries in an incoming byte stream and output received message packets.

## Inputs

1. **clk** (input): Clock signal for synchronizing operations.
2. **in[7:0]** (input): 8-bit input byte stream.
3. **reset** (input): Active high synchronous reset signal.

## Outputs

1. **out_bytes[23:0]** (output): 24-bit output containing the last received valid message.
   - `out_bytes[23:16]` represents the first byte.
   - `out_bytes[15:8]` represents the second byte.
   - `out_bytes[7:0]` represents the third byte.
2. **done** (output): Signal that asserts high when a complete message has been successfully detected and output.

## State Description

Design a finite state machine with the following states:

1. **Idle**: Initial state where the FSM waits for the start of a message.
    - Transition to "Byte1" when `in[3]` is high, indicating the start of a message.

2. **Byte1**: First byte of the message has been detected.
    - Capture the current byte as the first byte of the message.
    - Transition to "Byte2" on the next clock cycle.

3. **Byte2**: Second byte of the message is being received.
    - Capture the current byte as the second byte of the message.
    - Transition to "Byte3" on the next clock cycle.

4. **Byte3**: Third and final byte of the message is being received.
    - Capture the current byte as the third byte of the message.
    - Transition to "Done" to signal completion of message reception.

5. **Done**: Output the complete 3-byte message.
    - Assert `done` high to indicate a complete message has been received.
    - Transition back to "Idle" to prepare for the next message after acknowledging the done signal.

## Module Behavior

1. **Reset Condition**: 
   - On assertion of `reset`, the FSM should reset to the "Idle" state.

2. **Message Detection**:
   - The FSM discards bytes in "Idle" state until it detects a byte where `in[3] = 1`.
   - Once detected, it captures this byte as the first byte of the message, transitioning through states to capture the subsequent bytes.

3. **Output Signal**:
   - Once the full message is captured after the "Byte3" state, the `done` signal should be asserted high and `out_bytes` should hold the complete message.
   - After signaling completion, transition back to the "Idle" state to resume scanning the input stream for new messages.

## Timing Considerations

- **Clock Edge Alignment**: Ensure state transitions and signal updates occur on the rising edge of the `clk`.
- **Synchronization**: Maintain proper synchronization of the state transitions and output signal updates with respect to the `clk`.

## Notes

- The `out_bytes` signal can be considered a "don't-care" condition whenever the `done` signal is not asserted.
- It is assumed that there will be downstream logic to capture the `out_bytes` and `done` signals for further processing once asserted.