module top_module (
	input clk,
	input in,
	input reset,
	output out
);

	parameter A = 0;
	parameter B = 1;

	reg [1:0] state, next_state;
	reg out_r;

	always @(*) begin
		case (state)
			B: begin
				out_r = 1'b1;
				if (in)
					next_state = B;
				else
					next_state = A;
			end
			A: begin
				out_r = 1'b0;
				if (in)
					next_state = A;
				else
					next_state = B;
			end
			default: next_state = B; // Should not happen, but good practice
		endcase
	end

	always @(posedge clk) begin
		if (reset)
			state <= B;
		else
			state <= next_state;
	end

	always @(posedge clk) begin
		out <= out_r;
	end
endmodule