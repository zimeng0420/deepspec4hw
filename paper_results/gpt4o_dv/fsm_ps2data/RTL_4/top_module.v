module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);

    // Define the states of the FSM
    typedef enum reg [1:0] {IDLE, BYTE1, BYTE2, BYTE3} state_t;
    state_t state, next_state;

    // Registers to hold the incoming bytes
    reg [7:0] byte1, byte2, byte3;

    // FSM state transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            // Reset state and outputs
            state <= IDLE;
            done <= 0;
        end else begin
            // State transition
            state <= next_state;
            // Capture bytes and assign outputs based on current state
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        byte1 <= in;
                        done <= 0;
                    end
                end
                BYTE1: byte2 <= in;
                BYTE2: byte3 <= in;
                BYTE3: begin
                    out_bytes <= {byte1, byte2, byte3};
                    done <= 1;
                end
            endcase
        end
    end

    // Determine the next state
    always @(*) begin
        case (state)
            IDLE: next_state = in[3] ? BYTE1 : IDLE;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule