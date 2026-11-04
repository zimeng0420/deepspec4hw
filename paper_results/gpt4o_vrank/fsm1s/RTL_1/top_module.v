module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);
    
    typedef enum logic [1:0] {STATE_B = 1'b0, STATE_A = 1'b1} state_t;
    state_t state, next_state;

    always @(posedge clk) begin
        if (reset)
            state <= STATE_B;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            STATE_B: begin
                out = 1;
                if (in)
                    next_state = STATE_B;
                else
                    next_state = STATE_A;
            end
            STATE_A: begin
                out = 0;
                if (in)
                    next_state = STATE_A;
                else
                    next_state = STATE_B;
            end
            default: next_state = STATE_B;
        endcase
    end

endmodule