```verilog
module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg done
);

// State encoding
typedef enum logic [1:0] {
    IDLE        = 2'b00,
    BYTE_ONE    = 2'b01,
    BYTE_TWO    = 2'b10,
    BYTE_THREE  = 2'b11
} state_t;

// State and next state declarations
state_t current_state, next_state;

// State transition logic
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always_comb begin
    case (current_state)
        IDLE: begin
            done = 0;
            if (in[3] == 1) begin
                next_state = BYTE_ONE;
            end else begin
                next_state = IDLE;
            end
        end
        BYTE_ONE: begin
            done = 0;
            next_state = BYTE_TWO;
        end
        BYTE_TWO: begin
            done = 0;
            next_state = BYTE_THREE;
        end
        BYTE_THREE: begin
            done = 1;
            if (in[3] == 1) begin
                next_state = BYTE_ONE; // Treat current byte as start of a new message
            end else begin
                next_state = IDLE;
            end
        end
        default: begin
            done = 0;
            next_state = IDLE;
        end
    endcase
end

endmodule
```

**Technical Specification:**

1. **Inputs:**
   - `clk`: Clock input for synchronous operations.
   - `in`: 8-bit input representing the byte stream from the PS/2 mouse.
   - `reset`: Active high synchronous reset.

2. **Output:**
   - `done`: Output signal indicating the successful reception of a 3-byte message.

3. **FSM States:**
   - **IDLE**: Awaiting the start of a message (in[3]=1).
   - **BYTE_ONE**: First byte of the message has been detected (in[3]=1).
   - **BYTE_TWO**: Second byte of the message is being received.
   - **BYTE_THREE**: Third byte of the message is being received, `done` is set to 1 in the subsequent clock cycle.

4. **State Transitions:**
   - Transition from `IDLE` to `BYTE_ONE` when `in[3]` is detected as 1.
   - Progress through `BYTE_ONE` to `BYTE_TWO`, then `BYTE_TWO` to `BYTE_THREE`.
   - Once in `BYTE_THREE`, if `in[3]=1` in the next cycle, treat it as the start of a new message, else return to `IDLE`.

5. **Reset Behavior:**
   - On asserting `reset`, return to the `IDLE` state and `done` is set to 0.

6. **Timing:**
   - Next state logic and outputs are updated synchronously with the rising edge of `clk`.
   - `done` is activated in the cycle immediately following the receipt of the third byte (`BYTE_THREE` state).

This design ensures that the PS/2 mouse protocol messages are correctly delineated and processed within the byte stream.