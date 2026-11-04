module top_module (
	input clk,
	input areset,
	input bump_left,
	input bump_right,
	input ground,
	output reg walk_left,
	output reg walk_right,
	output reg aaah
);

	// State Definitions
	parameter WALK_LEFT  = 2'b00;
	parameter WALK_RIGHT = 2'b01;
	parameter FALLING    = 2'b10;

	// State Register
	reg [1:0] current_state;
	reg [1:0] next_state;

	// Combinational Logic for Next State
	always @(*) begin
		case (current_state)
			WALK_LEFT: begin
				if (bump_left)
					next_state = WALK_RIGHT;
				else if (ground == 0)
					next_state = FALLING;
				else
					next_state = WALK_LEFT;
			end
			WALK_RIGHT: begin
				if (bump_right)
					next_state = WALK_LEFT;
				else if (ground == 0)
					next_state = FALLING;
				else
					next_state = WALK_RIGHT;
			end
			FALLING: begin
				if (ground) {
					if (current_state == FALLING) begin
						if (walk_left)
							next_state = WALK_LEFT;
						else
							next_state = WALK_RIGHT;
					end
					else
						next_state = current_state;
				}
				else
					next_state = FALLING;
			end
			default:
				next_state = WALK_LEFT;
		endcase
	end

	// Combinational Logic for Outputs (Moore Machine)
	always @(*) begin
		case (current_state)
			WALK_LEFT: begin
				walk_left  = 1;
				walk_right = 0;
				aaah       = 0;
			end
			WALK_RIGHT: begin
				walk_left  = 0;
				walk_right = 1;
				aaah       = 0;
			end
			FALLING: begin
				walk_left  = 0;
				walk_right = 0;
				aaah       = 1;
			end
			default: begin
				walk_left  = 1;
				walk_right = 0;
				aaah       = 0;
			end
		endcase
	end

	// Sequential Logic for State Update
	always @(posedge clk or posedge areset) begin
		if (areset)
			current_state <= WALK_LEFT;
		else
			current_state <= next_state;
	end

endmodule