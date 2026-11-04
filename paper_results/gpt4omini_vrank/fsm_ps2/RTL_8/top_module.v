module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg done
);

    typedef enum reg [1:0] {
        WAIT_FOR_START = 2'b00,
        RECEIVE_BYTE1 = 2'b01,
        RECEIVE_BYTE2 = 2'b10,
        RECEIVE_BYTE3 = 2'b11
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= WAIT_FOR_START;
            done <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            WAIT_FOR_START: begin
                if (in[3] == 1) begin
                    next_state = RECEIVE_BYTE1;
                    done = 0;
                end else begin
                    next_state = WAIT_FOR_START;
                    done = 0;
                end
            end
            RECEIVE_BYTE1: begin
                next_state = RECEIVE_BYTE2;
                done = 0;
            end
            RECEIVE_BYTE2: begin
                next_state = RECEIVE_BYTE3;
                done = 0;
            end
            RECEIVE_BYTE3: begin
                next_state = WAIT_FOR_START;
                done = 1;
            end
            default: begin
                next_state = WAIT_FOR_START;
                done = 0;
            end
        endcase
    end

endmodule