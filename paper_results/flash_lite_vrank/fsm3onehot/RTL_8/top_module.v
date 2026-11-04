module top_module (
	input in,
	input [3:0] state,
	output reg [3:0] next_state,
	output out
);

	// Define states
	localparam A = 4'b0001;
	localparam B = 4'b0010;
	localparam C = 4'b0100;
	localparam D = 4'b1000;

	// State transition logic
	always @(*) begin
		case (state)
			A: next_state = (in == 0) ? A : B;
			B: next_state = (in == 0) ? C : B;
			C: next_state = (in == 0) ? A : D;
			D: next_state = (in == 0) ? C : B;
			default: next_state = A; // Default to state A
		endcase
	end

	// Output logic
	always @(*) begin
		case (state)
			D: out = 1'b1;
			default: out = 1'b0;
		endcase
	end

endmodule