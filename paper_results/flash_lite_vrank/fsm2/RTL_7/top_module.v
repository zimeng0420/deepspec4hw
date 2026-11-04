module top_module (
	input clk,
	input j,
	input k,
	input areset,
	output reg out
);

	parameter OFF = 0;
	parameter ON = 1;

	reg [1:0] state, next_state;

	always @(posedge clk or posedge areset) begin
		if (areset)
			state <= OFF;
		else
			state <= next_state;
	end

	always @(*) begin
		case (state)
			OFF: begin
				out = 0;
				next_state = (j == 1) ? ON : OFF;
			end
			ON: begin
				out = 1;
				next_state = (k == 1) ? OFF : ON;
			end
			default: begin
				out = 0;
				next_state = OFF;
			end
		endcase
	end

endmodule