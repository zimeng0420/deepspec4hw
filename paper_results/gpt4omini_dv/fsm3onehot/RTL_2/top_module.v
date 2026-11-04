module top_module (
	input in,
	input [3:0] state,
	output reg [3:0] next_state,
	output out
);

	assign out = state[3]; // Output logic: high if in state D

	always @(*) begin
		next_state = 4'b0000; // Default to zero

		// State transition logic
		if (state[0]) begin // State A
			if (in) next_state = 4'b0010; // Move to B
			else next_state = 4'b0001; // Stay in A
		end
		else if (state[1]) begin // State B
			if (in) next_state = 4'b0010; // Stay in B
			else next_state = 4'b0100; // Move to C
		end
		else if (state[2]) begin // State C
			if (in) next_state = 4'b1000; // Move to D
			else next_state = 4'b0001; // Move to A
		end
		else if (state[3]) begin // State D
			if (in) next_state = 4'b0010; // Move to B
			else next_state = 4'b0100; // Move to C
		end
	end

endmodule