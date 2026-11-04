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

	parameter IDLE = 0, WALK_LEFT = 1, WALK_RIGHT = 2, FALL = 3, DIGGING = 4;
	reg [2:0] state, next_state;
	reg walk_dir; // 0: left, 1: right
	reg digging_reg;

	always @(posedge clk or posedge areset) begin
		if (areset) begin
			state <= IDLE;
		end else begin
			state <= next_state;
		end
	end

	always @(*) begin
		next_state = state;
		walk_left = 0;
		walk_right = 0;
		aaah = 0;
		digging = digging_reg;

		case (state)
			IDLE: begin
				walk_left = 1;
				walk_dir = 0;
				next_state = WALK_LEFT;
			end
			WALK_LEFT: begin
				walk_left = 1;
				if (!ground) begin
					next_state = FALL;
					aaah = 1;
				end else if (bump_right) begin
					next_state = WALK_RIGHT;
					walk_dir = 1;
				end else if (dig && ground) begin
					next_state = DIGGING;
					digging_reg = 1;
				end
			end
			WALK_RIGHT: begin
				walk_right = 1;
				if (!ground) begin
					next_state = FALL;
					aaah = 1;
				end else if (bump_left) begin
					next_state = WALK_LEFT;
					walk_dir = 0;
				end else if (dig && ground) begin
					next_state = DIGGING;
					digging_reg = 1;
				end
			end
			FALL: begin
				aaah = 1;
				if (ground) begin
					if (walk_dir == 0)
						next_state = WALK_LEFT;
					else
						next_state = WALK_RIGHT;
				end
			end
			DIGGING: begin
				digging = 1;
				if (!ground) begin
					next_state = FALL;
					aaah = 1;
					digging_reg = 0;
				end
			end
			default: next_state = IDLE;
		endcase
		
		if (state == WALK_LEFT && bump_right) begin
			walk_dir = 1;
		end
		if (state == WALK_RIGHT && bump_left) begin
			walk_dir = 0;
		end
		
		if (state == FALL && ground) begin
			digging_reg = 0;
		end
		
		if (state == WALK_LEFT && dig && ground) begin
			digging_reg = 1;
		end

		if (state == WALK_RIGHT && dig && ground) begin
			digging_reg = 1;
		end
	end

endmodule