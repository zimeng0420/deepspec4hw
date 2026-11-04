module top_module (
	input clk,
	input areset,
	input bump_left,
	input bump_right,
	input ground,
	input dig,
	output walk_left,
	output walk_right,
	output aaah,
	output digging
);

	parameter WALKING_LEFT = 2'b00;
	parameter WALKING_RIGHT = 2'b01;
	parameter FALLING = 2'b10;
	parameter DIGGING = 2'b11;

	reg [1:0] state, next_state;
	reg prev_ground;

	always @(posedge clk or posedge areset) begin
		if (areset)
			state <= WALKING_LEFT;
		else
			state <= next_state;
	end

	always @(*) begin
		next_state = state;
		walk_left = 0;
		walk_right = 0;
		aaah = 0;
		digging = 0;

		case (state)
			WALKING_LEFT: begin
				walk_left = 1;
				if (!ground)
					next_state = FALLING;
				else if (dig && ground)
					next_state = DIGGING;
				else if (bump_right)
					next_state = WALKING_LEFT; // Will be updated later to WALKING_RIGHT
				else if (bump_left)
					next_state = WALKING_RIGHT;
			end
			WALKING_RIGHT: begin
				walk_right = 1;
				if (!ground)
					next_state = FALLING;
				else if (dig && ground)
					next_state = DIGGING;
				else if (bump_left)
					next_state = WALKING_RIGHT; // Will be updated later to WALKING_LEFT
				else if (bump_right)
					next_state = WALKING_LEFT;

			end
			FALLING: begin
				aaah = 1;
				if (ground) {
					if (state == FALLING)
					  if (walk_left)
					  	next_state = WALKING_LEFT;
					  else
					  	next_state = WALKING_RIGHT;
				}

			end
			DIGGING: begin
				digging = 1;
				if (!ground)
					next_state = FALLING;
			end
		endcase

		if (state == WALKING_LEFT && bump_right && next_state == WALKING_LEFT)
			next_state = WALKING_RIGHT;
		else if (state == WALKING_RIGHT && bump_left && next_state == WALKING_RIGHT)
			next_state = WALKING_LEFT;
	end

endmodule