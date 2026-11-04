module top_module (
	input clk,
	input in,
	input areset,
	output reg out
);

    // State encoding
    typedef enum reg [1:0] {STATE_A = 2'd0, STATE_B = 2'd1} state_t;
    reg state, next_state;

    // Combinational logic for next state and output
    always @(*) begin
        case (state)
            STATE_B: begin
                next_state = (in == 0) ? STATE_A : STATE_B;
                out = 1;
            end
            STATE_A: begin
                next_state = (in == 0) ? STATE_B : STATE_A;
                out = 0;
            end
            default: begin
                next_state = STATE_B;
                out = 1;
            end
        endcase
    end

    // Sequential logic for state transition
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_B;
        end else begin
            state <= next_state;
        end
    end
endmodule