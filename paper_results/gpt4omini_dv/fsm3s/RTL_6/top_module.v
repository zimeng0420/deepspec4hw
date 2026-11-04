module top_module (
	input clk,
	input in,
	input reset,
	output reg out
);

	// State encoding
	parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
	reg [1:0] current_state, next_state;

	// Next state logic
	always @(*) begin
		case (current_state)
			A: next_state = (in == 0) ? A : B;
			B: next_state = (in == 0) ? C : B;
			C: next_state = (in == 0) ? A : D;
			D: next_state = (in == 0) ? C : B;
			default: next_state = A; // Default to state A
		endcase
	end

	// Output logic
	always @(*) begin
		case (current_state)
			A, B, C: out = 0;
			D: out = 1;
			default: out = 0; // Default output to 0
		endcase
	end

	// State register with synchronous reset
	always @(posedge clk or posedge reset) begin
		if (reset) 
			current_state <= A; // Reset to state A
		else 
			current_state <= next_state; // Update current state
	end

endmodule