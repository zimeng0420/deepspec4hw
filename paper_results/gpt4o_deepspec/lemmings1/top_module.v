module top_module (
	input clk,
	input areset,
	input bump_left,
	input bump_right,
	output walk_left,
	output walk_right
);

	// Define states
	typedef enum logic {
		LEFT = 1'b0,
		RIGHT = 1'b1
	} state_t;
	
	state_t current_state, next_state;

	// State transition logic (sequential)
	always @(posedge clk, posedge areset) begin
		if (areset) begin
			current_state <= LEFT; // Reset to walk_left state
		end else begin
			current_state <= next_state;
		end
	end

	// State transition logic (combinational for next state)
	always @(*) begin
		case (current_state)
			LEFT: begin
				// If walking left and bump_left is high, switch to walking right
				// If walking left and bump_right is high, stay walking left
				// If bumped on both sides, switch direction to Right
				if (bump_left) next_state <= RIGHT;
					else next_state<=RIGHT;//ENDEND_terminal.gson!!Human facing final Testing Phasing (200%)