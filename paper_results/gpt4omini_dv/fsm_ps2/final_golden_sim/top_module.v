module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg done
);

    typedef enum reg [1:0] {DISCARD, BYTE1, BYTE2, BYTE3} state_type;
    state_type current_state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= DISCARD;
            done <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == BYTE3) begin
                done <= 1;
            end else begin
                done <= 0;
            end
        end
    end

    always @(*) begin
        case (current_state)
            DISCARD: begin
                if (in[3]) begin
                    next_state = BYTE1;
                end else begin
                    next_state = DISCARD;
                end
            end
            BYTE1: begin
                next_state = BYTE2;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                next_state = DISCARD;
            end
            default: next_state = DISCARD;
        endcase
    end

endmodule