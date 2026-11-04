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

	parameter IDLE = 0, WALK_LEFT = 1, WALK_RIGHT = 2, FALLING = 3, DIGGING = 4, SPLATTER = 5;
	reg [2:0] state, next_state;
	reg [5:0] fall_counter;
	reg walk_dir; // 0: left, 1: right

	always @(posedge clk or posedge areset) begin
		if (areset) begin
			state <= WALK_LEFT;
			fall_counter <= 0;
			walk_dir <= 0;
		end else begin
			state <= next_state;
			if (state == FALLING && ground) begin
				fall_counter <= 0;
			end else if (state == FALLING) begin
				fall_counter <= fall_counter + 1;
			end
		end
	end

	always @(*) begin
		next_state = state;
		walk_left = 0;
		walk_right = 0;
		aaah = 0;
		digging = 0;

		case (state)
			IDLE: begin
				next_state = WALK_LEFT;
			end
			WALK_LEFT: begin
				walk_left = 1;
				if (bump_right) begin
					next_state = WALK_LEFT;
				end else if (bump_left) begin
					next_state = WALK_RIGHT;
					walk_dir = 1;
				end else if (!ground) begin
					next_state = FALLING;
				end else if (dig) begin
					next_state = DIGGING;
				end
			end
			WALK_RIGHT: begin
				walk_right = 1;
				if (bump_left) begin
					next_state = WALK_RIGHT;
				end else if (bump_right) begin
					next_state = WALK_LEFT;
					walk_dir = 0;
				end else if (!ground) begin
					next_state = FALLING;
				end else if (dig) begin
					next_state = DIGGING;
				end
			end
			FALLING: begin
				aaah = 1;
				if (ground) begin
					if (fall_counter > 20) begin
						next_state = SPLATTER;
					end else begin
						if (walk_dir == 0)
							next_state = WALK_LEFT;
						else
							next_state = WALK_RIGHT;
					end
				end
			end
			DIGGING: begin
				digging = 1;
				if (!ground) begin
					next_state = FALLING;
				end
			end
			SPLATTER: begin
				// All outputs are already 0
				next_state = SPLATTER;
			end
			default: next_state = IDLE;
		endcase
	end

endmodule