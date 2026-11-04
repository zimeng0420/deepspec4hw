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
	reg walk_left_r, walk_right_r, aaah_r, digging_r;

	always @(posedge clk or posedge areset) begin
		if (areset) begin
			state <= IDLE;
			fall_counter <= 6'd0;
			walk_left_r <= 1'b1;
			walk_right_r <= 1'b0;
			aaah_r <= 1'b0;
			digging_r <= 1'b0;
		end else begin
			state <= next_state;
			if (next_state == FALLING) begin
				fall_counter <= fall_counter + 1'b1;
			end else begin
				fall_counter <= 6'd0;
			end
		end
	end

	always @(*) begin
		next_state = state;
		walk_left_r = 1'b0;
		walk_right_r = 1'b0;
		aaah_r = 1'b0;
		digging_r = 1'b0;

		case (state)
			IDLE: begin
                walk_left_r = 1'b1;
				next_state = WALK_LEFT;
            end
			WALK_LEFT: begin
				if (ground == 1'b0) begin
					next_state = FALLING;
					aaah_r = 1'b1;
				end else if (dig == 1'b1) begin
					next_state = DIGGING;
					digging_r = 1'b1;
				end else if (bump_right == 1'b1) begin
					next_state = WALK_RIGHT;
					walk_right_r = 1'b1;
				end
				else begin
					walk_left_r = 1'b1;
				end
			end
			WALK_RIGHT: begin
				if (ground == 1'b0) begin
					next_state = FALLING;
					aaah_r = 1'b1;
				end else if (dig == 1'b1) begin
					next_state = DIGGING;
					digging_r = 1'b1;
				end else if (bump_left == 1'b1) begin
					next_state = WALK_LEFT;
					walk_left_r = 1'b1;
				end
				else begin
					walk_right_r = 1'b1;
				end
			end
			FALLING: begin
				aaah_r = 1'b1;
				if (ground == 1'b1) begin
					if (fall_counter > 6'd20) begin
						next_state = SPLATTER;
					end else if (walk_left_r == 1'b1) {
                        next_state = WALK_LEFT;
                        walk_left_r = 1'b1;
                    } else {
                        next_state = WALK_RIGHT;
                        walk_right_r = 1'b1;
                    }
				end
			end
			DIGGING: begin
				digging_r = 1'b1;
				if (ground == 1'b0) begin
					next_state = FALLING;
					aaah_r = 1'b1;
				end
			end
			SPLATTER: begin
				// All outputs are already 0 in the beginning of the always block
			end
			default: next_state = IDLE;
		endcase
	end

	assign walk_left = walk_left_r;
	assign walk_right = walk_right_r;
	assign aaah = aaah_r;
	assign digging = digging_r;

endmodule