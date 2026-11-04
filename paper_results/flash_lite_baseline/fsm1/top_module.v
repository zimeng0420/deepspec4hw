module top_module (
	input clk,
	input in,
	input areset,
	output out
);

	parameter A = 2'b00;
	parameter B = 2'b01;

	reg [1:0] state, next_state;

	// State register
	always @(posedge clk or posedge areset) begin
		if (areset)
			state <= B;
		else
			state <= next_state;
	end

	// Next state logic
	always @(*) begin
		case (state)
			B:
				if (in)
					next_state = B;
				else
					next_state = A;
			A:
				if (in)
					next_state = A;
				else
					next_state = B;
			default:
				next_state = B; // Default to B for safety
		endcase
	end

	// Output logic
	always @(*) begin
		case (state)
			A:
				out = 1'b0;
			B:
				out = 1'b1;
			default:
				out = 1'b1; // Default to B for safety
		endcase
	end

endmodule