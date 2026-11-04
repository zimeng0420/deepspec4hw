module top_module (
	input clk,
	input reset,
	input in,
	output reg disc,
	output reg flag,
	output reg err
);

typedef enum logic [2:0] {
	S0, // Initial state, waiting for first 0 or 1
	S1, // First 1 detected
	S2, // Second 1 detected
	S3, // Third 1 detected
	S4, // Fourth 1 detected
	S5, // Fifth 1 detected
	S6, // Sixth 1 detected (flag)
	S7  // Seventh 1 detected (error)
} state_t;

state_t current_state, next_state;

always_ff @(posedge clk) begin
	if (reset) begin
		current_state <= S0;
		disc <= 0;
		flag <= 0;
		err <= 0;
	end else begin
		current_state <= next_state;
		disc <= 0; // Default state
		flag <= 0; // Default state
		err <= 0;  // Default state
	end
end

always_comb begin
	next_state = current_state;
	case (current_state)
		S0: begin
			if (in) next_state = S1;
			else next_state = S0;
		end
		S1: begin
			if (in) next_state = S2;
			else next_state = S0;
		end
		S2: begin
			if (in) next_state = S3;
			else next_state = S0;
		end
		S3: begin
			if (in) next_state = S4;
			else next_state = S0;
		end
		S4: begin
			if (in) next_state = S5;
			else next_state = S0;
		end
		S5: begin
			if (in) next_state = S6;
			else next_state = S0;
		end
		S6: begin
			if (in) next_state = S7;   // Transition to error state
			else begin
				next_state = S0; 
				disc = 1; // Signal to discard
			end
		end
		S7: begin
			if (in) next_state = S7; // Remain in error state
			else next_state = S0; // Reset on 0
			err = 1; // Signal error
		end
		default: next_state = S0;
	endcase

	if (next_state == S6) begin
		flag = 1; // Signal flag if we transition to flag state
	end
end

endmodule