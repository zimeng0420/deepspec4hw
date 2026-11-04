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
	parameter FALLING_LEFT = 2'b10;
	parameter FALLING_RIGHT = 2'b11;

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
				aaah = 1'b0;
				if (!ground)
					next_state = FALLING_LEFT;
				else if (bump_left)
					next_state = WALKING_RIGHT;
				else if (bump_right)
					next_state = WALKING_RIGHT;
				else
					next_state = WALKING_LEFT;
			end
			WALKING_RIGHT: begin
				aaah = 1'b0;
				if (!ground)
					next_state = FALLING_RIGHT;
				else if (bump_left)
					next_state = WALKING_LEFT;
				else if (bump_right)
					next_state = WALKING_LEFT;
				else
					next_state = WALKING_RIGHT;
			end
			FALLING_LEFT: begin
				aaah = 1'b1;
				if (ground)
					next_state = WALKING_LEFT;
				else
					next_state = FALLING_LEFT;
			end
			FALLING_RIGHT: begin
				aaah = 1'b1;
				if (ground)
					next_state = WALKING_RIGHT;
				else
					next_state = FALLING_RIGHT;
			end
			default: next_state = WALKING_LEFT;
		endcase
	end

	always @(*) begin
		case (state)
			WALKING_LEFT: begin
				walk_left = 1'b1;
				walk_right = 1'b0;
			end
			WALKING_RIGHT: begin
				walk_left = 1'b0;
				walk_right = 1'b1;
			end
			FALLING_LEFT: begin
				walk_left = 1'b1;
				walk_right = 1'b0;
			end
			FALLING_RIGHT: begin
				walk_left = 1'b0;
				walk_right = 1'b1;
			end
			default: begin
				walk_left = 1'b1;
				walk_right = 1'b0;
			end
		endcase
	end
end