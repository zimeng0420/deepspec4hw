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

	parameter IDLE = 0;
	parameter WALK_LEFT = 1;
	parameter WALK_RIGHT = 2;
	parameter FALL = 3;
	parameter DIG = 4;
	parameter SPLATTER = 5;

	reg [2:0] state, next_state;
	reg [6:0] fall_counter;
	reg walk_left_r, walk_right_r, aaah_r, digging_r;

	always @(posedge clk or posedge areset) begin
		if (areset) begin
			state <= WALK_LEFT;
			fall_counter <= 7'b0;
			walk_left_r <= 1'b1;
			walk_right_r <= 1'b0;
			aaah_r <= 1'b0;
			digging_r <= 1'b0;
		end else begin
			state <= next_state;
			walk_left_r <= (next_state == WALK_LEFT);
			walk_right_r <= (next_state == WALK_RIGHT);
			aaah_r <= (next_state == FALL);
			digging_r <= (next_state == DIG);
			if (next_state == FALL && ground == 1'b1) begin
				fall_counter <= 7'b0;
			end
			else if (next_state == FALL)
				fall_counter <= fall_counter + 1'b1;
			else
				fall_counter <= 7'b0;

		end
	end


	always @(*) begin
		next_state = state;
		walk_left = walk_left_r;
		walk_right = walk_right_r;
		aaah = aaah_r;
		digging = digging_r;
		case (state)
			IDLE: begin
				next_state = IDLE;
			end
			WALK_LEFT: begin
				if (!ground) begin
					next_state = FALL;
				end else if (bump_right) begin
					next_state = WALK_RIGHT;
				end else if (dig && ground) begin
					next_state = DIG;
				end
			end
			WALK_RIGHT: begin
				if (!ground) begin
					next_state = FALL;
				end else if (bump_left) begin
					next_state = WALK_LEFT;
				end else if (dig && ground) begin
					next_state = DIG;
				end
			end
			FALL: begin
				if (ground) begin
					if (fall_counter > 20) begin
						next_state = SPLATTER;
					end else begin
						if (walk_left_r)
							next_state = WALK_LEFT;
						else
							next_state = WALK_RIGHT;
					end
				end
			end
			DIG: begin
				if (!ground) begin
					next_state = FALL;
				end
			end
			
			SPLATTER: begin
				next_state = SPLATTER;
				walk_left = 1'b0;
				walk_right = 1'b0;
				aaah = 1'b0;
				digging = 1'b0;

			end
			default: next_state = IDLE;
		endcase
	end

endmodule