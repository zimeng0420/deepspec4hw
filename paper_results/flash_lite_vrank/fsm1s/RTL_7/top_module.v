module top_module (
	input clk,
	input in,
	input reset,
	output out
);

	parameter A = 2'b00;
	parameter B = 2'b01;

	reg [1:0] state, next_state;

	// State transition logic
	always @(posedge clk) begin
		if (reset)
			state <= B;
		else
			state <= next_state;
	end

	// Next state logic
	always @(*) begin
		case (state)
			B:
				next_state = in ? B : A;
			A:
				next_state = in ? A : B;
			default:
				next_state = B; // Should not happen
		endcase
	end

	// Output logic
	always @(*) begin
		case (state)
			B:
				out = 1'b1;
			A:
				out = 1'b0;
			default:
				out = 1'b1; // Should not happen
		endcase
	end

endmodule