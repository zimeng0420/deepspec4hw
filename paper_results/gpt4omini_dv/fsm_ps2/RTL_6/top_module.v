module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg done
);

    typedef enum reg [1:0] {
        DISCARD,
        BYTE1,
        BYTE2,
        BYTE3
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (reset) 
            state <= DISCARD;
        else 
            state <= next_state;
    end

    always @(*) begin
        case (state)
            DISCARD: begin
                if (in[3] == 1)
                    next_state = BYTE1;
                else
                    next_state = DISCARD;
                done = 0;
            end
            BYTE1: begin
                next_state = BYTE2;
                done = 0;
            end
            BYTE2: begin
                next_state = BYTE3;
                done = 0;
            end
            BYTE3: begin
                next_state = DISCARD;
                done = 1;
            end
            default: begin
                next_state = DISCARD;
                done = 0;
            end
        endcase
    end

endmodule