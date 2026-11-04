module top_module (
	input clk,
	input j,
	input k,
	input reset,
	output out
);

	parameter OFF = 0;
	parameter ON  = 1;

	reg [1:0] state, next_state;

	always @(*) begin
		case (state)
			OFF:
				next_state = (j == 1) ? ON : OFF;
			ON:
				next_state = (k == 1) ? OFF : ON;
			default:
				next_state = OFF;
		endcase
	end

	always @(posedge clk) begin
		if (reset)
			state <= OFF;
		else
			state <= next_state;
	end

	always @(*) begin
		case (state)
			OFF:
				out = 0;
			ON:
				out = 1;
			default:
				out = 0;
		endcase
	end

endmodule