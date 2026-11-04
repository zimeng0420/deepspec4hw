module top_module (
	input clk,
	input areset,
	input bump_left,
	input bump_right,
	input ground,
	output walk_left,
	output walk_right,
	output aaah
);

	parameter WALKING_LEFT = 2'b00;
	parameter WALKING_RIGHT = 2'b01;
	parameter FALLING = 2'b10;

	reg [1:0] state, next_state;

	always @(posedge clk or posedge areset) begin
		if (areset)
			state <= WALKING_LEFT;
		else
			state <= next_state;
	end

	always @(*) begin
		next_state = state;
		case (state)
			WALKING_LEFT: begin
				if (bump_left)
					next_state = WALKING_RIGHT;
				else if (ground == 0)
					next_state = FALLING;
			end
			WALKING_RIGHT: begin
				if (bump_right)
					next_state = WALKING_LEFT;
				else if (ground == 0)
					next_state = FALLING;
			end
			FALLING: begin
				if (ground == 1)
					next_state = (state == FALLING) ? ((walk_left) ? WALKING_LEFT : WALKING_RIGHT) : state; // Resume walking direction, which is left or right.
			end
		endcase
	end

	always @(*) begin
		case (state)
			WALKING_LEFT: begin
				walk_left = 1;
				walk_right = 0;
				aaah = 0;
			end
			WALKING_RIGHT: begin
				walk_left = 0;
				walk_right = 1;
				aaah = 0;
			end
			FALLING: begin
				walk_left = 0;
				walk_right = 0;
				aaah = 1;
			end
			default: begin
				walk_left = 1;
				walk_right = 0;
				aaah = 0;
			end
		endcase
	end

endmodule