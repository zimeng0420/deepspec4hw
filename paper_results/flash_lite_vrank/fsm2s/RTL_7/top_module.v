module top_module (
	input clk,
	input j,
	input k,
	input reset,
	output out
);

	parameter OFF = 2'b00;
	parameter ON  = 2'b01;

	reg [1:0] state, next_state;
	reg out_r;

	always @(posedge clk) begin
		if (reset)
			state <= OFF;
		else
			state <= next_state;
	end

	always @(*) begin
		case (state)
			OFF: begin
				out_r = 1'b0;
				next_state = (j) ? ON : OFF;
			end
			ON: begin
				out_r = 1'b1;
				next_state = (k) ? OFF : ON;
			end
			default: begin
				out_r = 1'b0;
				next_state = OFF;
			end
		endcase
	end

	assign out = out_r;

endmodule