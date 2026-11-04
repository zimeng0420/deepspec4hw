module top_module (
	input clk,
	input areset,
	input bump_left,
	input bump_right,
	output walk_left,
	output walk_right
);

	parameter WALK_LEFT_STATE = 0;
	parameter WALK_RIGHT_STATE = 1;

	reg [1:0] current_state, next_state;

	// State transition logic
	always @(posedge clk or posedge areset) begin
		if (areset)
			current_state <= WALK_LEFT_STATE;
		else
			current_state <= next_state;
	end

	// Next state logic
	always @(*) begin
		case (current_state)
			WALK_LEFT_STATE:
				if (bump_left || bump_right)
					next_state = WALK_RIGHT_STATE;
				else
					next_state = WALK_LEFT_STATE;
			WALK_RIGHT_STATE:
				if (bump_left || bump_right)
					next_state = WALK_LEFT_STATE;
				else
					next_state = WALK_RIGHT_STATE;
			default:
				next_state = WALK_LEFT_STATE; // Default to walk left
		endcase
	end

	// Output logic
	always @(*) begin
		case (current_state)
			WALK_LEFT_STATE: begin
				walk_left = 1;
				walk_right = 0;
			end
			WALK_RIGHT_STATE: begin
				walk_left = 0;
				walk_right = 1;
			end
			default: begin
				walk_left = 1;
				walk_right = 0;
			end
		endcase
	end

endmodule