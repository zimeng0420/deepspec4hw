module top_module (
	input clk,
	input areset,
	input bump_left,
	input bump_right,
	output walk_left,
	output walk_right
);

	// State Definition
	parameter WALK_LEFT = 0;
	parameter WALK_RIGHT = 1;

	// Internal State Register
	reg [0:0] current_state;
	reg [0:0] next_state;

	// Combinational Logic for Next State
	always @(*) begin
		case (current_state)
			WALK_LEFT: begin
				if (bump_right)
					next_state = WALK_RIGHT;
				else
					next_state = WALK_LEFT;
			end
			WALK_RIGHT: begin
				if (bump_left)
					next_state = WALK_LEFT;
				else
					next_state = WALK_RIGHT;
			end
			default:
				next_state = WALK_LEFT; // Default to WALK_LEFT
		endcase
	end

	// Sequential Logic for State Update
	always @(posedge clk or posedge areset) begin
		if (areset)
			current_state <= WALK_LEFT;
		else
			current_state <= next_state;
	end

	// Combinational Logic for Output
	always @(*) begin
		case (current_state)
			WALK_LEFT: begin
				walk_left = 1;
				walk_right = 0;
			end
			WALK_RIGHT: begin
				walk_left = 0;
				walk_right = 1;
			end
			default: begin
				walk_left = 1; // Default to WALK_LEFT
				walk_right = 0;
			end
		endcase
	end

endmodule