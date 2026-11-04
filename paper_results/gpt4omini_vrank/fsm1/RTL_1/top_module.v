module top_module (
	input clk,
	input in,
	input areset,
	output reg out
);

typedef enum reg [1:0] {
	A = 1'b0,
	B = 1'b1
} state_t;

state_t state, next_state;

always @(posedge clk or posedge areset) begin
	if (areset) begin
		state <= B; // Reset to state B
	end else begin
		state <= next_state; // Move to next state
	end
end

always @(*) begin
	case (state)
		A: begin
			if (in == 0) begin
				next_state = B;
			end else begin
				next_state = A;
			end
			out = 0; // Output for state A
		end
		B: begin
			if (in == 0) begin
				next_state = A;
			end else begin
				next_state = B;
			end
			out = 1; // Output for state B
		end
		default: begin
			next_state = B;
			out = 1; // Default output for error state
		end
	endcase
end

endmodule