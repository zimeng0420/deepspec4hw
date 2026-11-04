module top_module (
	input clk,
	input in,
	input reset,
	output out
);

	parameter A = 2'b00;
	parameter B = 2'b01;

	reg [1:0] state, next_state;
	reg out_reg;

	always @(posedge clk) begin
		if (reset)
			state <= B;
		else
			state <= next_state;
	end

	always @(*) begin
		case (state)
			B: begin
				out_reg = 1'b1;
				if (in)
					next_state = B;
				else
					next_state = A;
			end
			A: begin
				out_reg = 1'b0;
				if (in)
					next_state = A;
				else
					next_state = B;
			end
			default: begin
				out_reg = 1'b0;
				next_state = B; // Default to B for safety
			end
		endcase
	end

	assign out = out_reg;

endmodule