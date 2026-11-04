module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);

    // FSM States
    typedef enum reg [1:0] {
        WAITING = 2'b00,
        BYTE1   = 2'b01,
        BYTE2   = 2'b10,
        BYTE3   = 2'b11
    } state_t;

    state_t state, next_state;
    reg [23:0] message_buffer;

    always @(posedge clk) begin
        if (reset) begin
            state <= WAITING;
            message_buffer <= 24'b0;
            done <= 0;
            out_bytes <= 24'b0;
        end else begin
            state <= next_state;
            if (done) out_bytes <= message_buffer;
        end
    end

    always @(*) begin
        next_state = state;
        done = 0;

        case(state)
            WAITING: begin
                if (in[3] == 1) begin
                    next_state = BYTE1;
                    message_buffer[23:16] = in;
                end
            end
            BYTE1: begin
                next_state = BYTE2;
                message_buffer[15:8] = in;
            end
            BYTE2: begin
                next_state = BYTE3;
                message_buffer[7:0] = in;
            end
            BYTE3: begin
                done = 1;
                next_state = WAITING;
            end
        endcase
    end

endmodule