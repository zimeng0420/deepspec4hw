module top_module (
	input clk,
	input in,
	input areset,
	output reg out
);

	typedef enum reg [1:0] {A, B} state_t;
	state_t current_state, next_state;

	// Asynchronous reset
	always @(*) begin
		if (areset) begin
			next_state = B;
		end else begin
			case (current_state)
				A: next_state = (in == 0) ? B : A;
				B: next_state = (in == 0) ? A : B;
				default: next_state = B; // Default to state B for safety
			endcase
		end
	end

	// State transition on clock edge
	always @(posedge clk or posedge areset) begin
		if (areset) begin
			current_state <= B;
		end else begin
			current_state <= next_state;
		end
	end

	// Output logic for Moore machine
	always @(*) begin
		case (current_state)
			A: out = 0;
			B: out = 1;
			default: out = 0; // Default output
		endcase
	end

endmodule