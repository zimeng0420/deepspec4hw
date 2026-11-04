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
				aaah = 0;
				if (ground == 0)
					next_state = FALLING_LEFT;
				else if (bump_left)
					next_state = WALKING_RIGHT;
			end
			WALKING_RIGHT: begin
				aaah = 0;
				if (ground == 0)
					next_state = FALLING_RIGHT;
				else if (bump_right)
					next_state = WALKING_LEFT;
			end
			FALLING_LEFT: begin
				aaah = 1;
				if (ground == 1)
					next_state = WALKING_LEFT;
			end
			FALLING_RIGHT: begin
				aaah = 1;
				if (ground == 1)
					next_state = WALKING_RIGHT;
			end
		endcase
	end

	always @(*) begin
		walk_left = (state == WALKING_LEFT || state == FALLING_LEFT);
		walk_right = (state == WALKING_RIGHT || state == FALLING_RIGHT);
	end

endmodule