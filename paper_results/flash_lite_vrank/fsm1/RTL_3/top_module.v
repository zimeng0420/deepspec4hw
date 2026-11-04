module top_module (
	input clk,
	input in,
	input areset,
	output out
);

	parameter A = 2'b00;
	parameter B = 2'b01;

	reg [1:0] state, next_state;
	reg out_reg;

	// State transition logic
	always @(*) begin
		case (state)
			B:
				next_state = in ? B : A;
			A:
				next_state = in ? A : B;
			default:
				next_state = B; // Default to B, just in case
		endcase
	end

	// Output logic
	always @(*) begin
		case (state)
			A:
				out_reg = 1'b0;
			B:
				out_reg = 1'b1;
			default:
				out_reg = 1'b1; // Default to B's output
		endcase
	end

	// State register
	always @(posedge clk or posedge areset) begin
		if (areset)
			state <= B;
		else
			state <= next_state;
	end

	assign out = out_reg;

endmodule