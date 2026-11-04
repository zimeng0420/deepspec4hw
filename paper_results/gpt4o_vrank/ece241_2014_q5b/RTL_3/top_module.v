module top_module (
	input clk,
	input areset,
	input x,
	output reg z
);

    // State encoding
    typedef enum logic [1:0] {
        STATE_A = 2'b01,
        STATE_B = 2'b10
    } state_t;
    
    state_t state, next_state;

    // State transition logic
    always_comb begin
        case(state)
            STATE_A: begin
                if (x == 0) begin
                    next_state = STATE_A;
                    z = 0;
                end
                else begin
                    next_state = STATE_B;
                    z = 1;
                end
            end
            STATE_B: begin
                if (x == 0) begin
                    next_state = STATE_B;
                    z = 1;
                end
                else begin
                    next_state = STATE_B;
                    z = 0;
                end
            end
            default: begin
                next_state = STATE_A;
                z = 0;
            end
        endcase
    end

    // State register update
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_A;
        end
        else begin
            state <= next_state;
        end
    end

endmodule