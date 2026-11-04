module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);

    // State definitions
    typedef enum reg [1:0] {
        IDLE = 2'b00,
        BYTE1 = 2'b01,
        BYTE2 = 2'b10,
        BYTE3 = 2'b11
    } state_type;

    // State, next state, and byte storage registers
    reg [1:0] state, next_state;
    reg [7:0] byte1, byte2, byte3;

    // State transition and sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte1 <= 0;
            byte2 <= 0;
            byte3 <= 0;
            out_bytes <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            case (state)
                BYTE1: byte1 <= in;
                BYTE2: byte2 <= in;
                BYTE3: byte3 <= in;
            endcase
            if (state == BYTE3) begin
                out_bytes <= {byte1, byte2, in};
                done <= 1;
            end else begin
                done <= 0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = (in[3]) ? BYTE1 : IDLE;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = (in[3]) ? BYTE1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule