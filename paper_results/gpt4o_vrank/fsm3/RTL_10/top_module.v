module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);

    typedef enum logic [1:0] {
        STATE_A = 2'b00,
        STATE_B = 2'b01,
        STATE_C = 2'b10,
        STATE_D = 2'b11
    } state_t;
    
    state_t state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_A;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        case (state)
            STATE_A: begin
                next_state = (in) ? STATE_B : STATE_A;
                out = 0;
            end
            STATE_B: begin
                next_state = (in) ? STATE_B : STATE_C;
                out = 0;
            end
            STATE_C: begin
                next_state = (in) ? STATE_D : STATE_A;
                out = 0;
            end
            STATE_D: begin
                next_state = (in) ? STATE_B : STATE_C;
                out = 1;
            end
            default: begin
                next_state = STATE_A;
                out = 0;
            end
        endcase
    end

endmodule