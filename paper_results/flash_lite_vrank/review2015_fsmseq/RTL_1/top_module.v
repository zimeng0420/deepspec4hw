module top_module(
	input clk,
	input reset,
	input data,
	output start_shifting
);

    parameter IDLE = 0, S1 = 1, S11 = 2, S110 = 3, S1101 = 4;
    reg [2:0] state, next_state;
    reg [3:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            if (start_shifting == 1'b0) begin
                shift_reg <= {shift_reg[2:0], data};
            end
        end
    end

    always @(*) begin
        next_state = state;
        start_shifting = 1'b0; //default value.

        case (state)
            IDLE: begin
                if (data)
                    next_state = S1;
            end
            S1: begin
                if (data)
                    next_state = S11;
                else
                    next_state = IDLE;
            end
            S11: begin
                if (!data)
                    next_state = S110;
                else
                    next_state = S11;
            end
            S110: begin
                if (data) {
                    next_state = S1101;
                }
                else
                    next_state = IDLE;
            end
            S1101: begin
                start_shifting = 1'b1;
                next_state = S1101;  // stay in this state
            end
            default: next_state = IDLE;
        endcase
    end

endmodule