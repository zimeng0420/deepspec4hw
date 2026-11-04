module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);

    typedef enum reg [1:0] {STATE_IDLE, STATE_BYTE1, STATE_BYTE2, STATE_BYTE3} state_t;
    state_t state, next_state;
    reg [7:0] byte1, byte2, byte3;

    // State transition logic
    always @(*) begin
        case (state)
            STATE_IDLE: next_state = (in[3]) ? STATE_BYTE1 : STATE_IDLE;
            STATE_BYTE1: next_state = STATE_BYTE2;
            STATE_BYTE2: next_state = STATE_BYTE3;
            STATE_BYTE3: next_state = STATE_IDLE;
            default: next_state = STATE_IDLE;
        endcase
    end

    // State flip-flops with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    always @(posedge clk) begin
        if (reset) begin
            done <= 0;
            out_bytes <= 24'bx;
        end else begin
            done <= (state == STATE_BYTE3);
            case (state)
                STATE_BYTE1: byte1 <= in;
                STATE_BYTE2: byte2 <= in;
                STATE_BYTE3: byte3 <= in;
            endcase

            if (state == STATE_BYTE3) begin
                out_bytes <= {byte1, byte2, byte3};
            end
        end
    end

endmodule