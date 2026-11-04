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

	parameter S_WALK_LEFT = 2'b00;
	parameter S_WALK_RIGHT = 2'b01;
	parameter S_FALL_LEFT = 2'b10;
	parameter S_FALL_RIGHT = 2'b11;

	reg [1:0] state, next_state;
	reg walk_left_r, walk_right_r, aaah_r;

	always @(posedge clk or posedge areset) begin
		if (areset) begin
			state <= S_WALK_LEFT;
		end else begin
			state <= next_state;
		end
	end

	always @(*) begin
		next_state = state;
		walk_left_r = 0;
		walk_right_r = 0;
		aaah_r = 0;

		case (state)
			S_WALK_LEFT: begin
				walk_left_r = 1;
				if (!ground) begin
					next_state = S_FALL_LEFT;
					aaah_r = 1;
				end else if (bump_right) begin
					next_state = S_WALK_RIGHT;
				end
			end
			S_WALK_RIGHT: begin
				walk_right_r = 1;
				if (!ground) begin
					next_state = S_FALL_RIGHT;
					aaah_r = 1;
				end else if (bump_left) begin
					next_state = S_WALK_LEFT;
				end
			end
			S_FALL_LEFT: begin
				aaah_r = 1;
				if (ground) begin
					next_state = S_WALK_LEFT;
				end
			end
			S_FALL_RIGHT: begin
				aaah_r = 1;
				if (ground) begin
					next_state = S_WALK_RIGHT;
				end
			end
			default: begin
				next_state = S_WALK_LEFT;
			end
		endcase
	end

	assign walk_left = walk_left_r;
	assign walk_right = walk_right_r;
	assign aaah = aaah_r;

endmodule