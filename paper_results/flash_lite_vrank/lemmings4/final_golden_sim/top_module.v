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

	parameter S_WALK_LEFT = 2'b00;
	parameter S_WALK_RIGHT = 2'b01;
	parameter S_FALL = 2'b10;
	parameter S_DIG = 2'b11;

	reg [1:0] state, next_state;
	reg [4:0] fall_counter;
	reg walk_left_r, walk_right_r, aaah_r, digging_r;

	always @(posedge clk or posedge areset) begin
		if (areset) begin
			state <= S_WALK_LEFT;
			fall_counter <= 0;
			walk_left_r <= 1;
			walk_right_r <= 0;
			aaah_r <= 0;
			digging_r <= 0;
		end else begin
			state <= next_state;
		end
	end

	always @(*) begin
		next_state = state;
		walk_left_r = 0;
		walk_right_r = 0;
		aaah_r = 0;
		digging_r = 0;
		fall_counter = fall_counter;

		case (state)
			S_WALK_LEFT: begin
				walk_left_r = 1;
				fall_counter = 0;
				if (!ground) begin
					next_state = S_FALL;
					aaah_r = 1;
				end else if (dig && ground) begin
					next_state = S_DIG;
					digging_r = 1;
				end else if (bump_right) begin
					next_state = S_WALK_RIGHT;
					walk_right_r = 1;
				end
			end

			S_WALK_RIGHT: begin
				walk_right_r = 1;
				fall_counter = 0;
				if (!ground) begin
					next_state = S_FALL;
					aaah_r = 1;
				end else if (dig && ground) begin
					next_state = S_DIG;
					digging_r = 1;
				end else if (bump_left) begin
					next_state = S_WALK_LEFT;
					walk_left_r = 1;
				end
			end

			S_FALL: begin
				aaah_r = 1;
				fall_counter = fall_counter + 1;
				if (ground) begin
					if (fall_counter > 20) begin
						next_state = state;
					end else begin
						if (walk_left_r)
							next_state = S_WALK_LEFT;
						else
							next_state = S_WALK_RIGHT;
					end
					fall_counter = 0;
				end
			end

			S_DIG: begin
				digging_r = 1;
				fall_counter = 0;
				if (!ground) begin
					next_state = S_FALL;
					aaah_r = 1;
				end
			end

			default: begin
				next_state = S_WALK_LEFT;
				walk_left_r = 1;
				walk_right_r = 0;
				aaah_r = 0;
				digging_r = 0;
				fall_counter = 0;
			end
		endcase
	end

	assign walk_left = (fall_counter > 20) ? 0 : walk_left_r;
	assign walk_right = (fall_counter > 20) ? 0 : walk_right_r;
	assign aaah = (fall_counter > 20) ? 0 : aaah_r;
	assign digging = (fall_counter > 20) ? 0 : digging_r;

endmodule