module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg done
);

    typedef enum reg [1:0] {
        IDLE,
        BYTE1,
        BYTE2,
        BYTE3
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            done <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            IDLE: begin
                done = 0;
                if (in[3] == 1) begin
                    next_state = BYTE1;
                end else begin
                    next_state = IDLE;
                end
            end
            
            BYTE1: begin
                done = 0;
                next_state = BYTE2;
            end

            BYTE2: begin
                done = 0;
                next_state = BYTE3;
            end

            BYTE3: begin
                done = 1;
                next_state = IDLE;
            end

            default: begin
                done = 0;
                next_state = IDLE;
            end
        endcase
    end

endmodule