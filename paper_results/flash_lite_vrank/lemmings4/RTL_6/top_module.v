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

	parameter WALK_LEFT = 2'b00;
	parameter WALK_RIGHT = 2'b01;
	parameter FALLING = 2'b10;
	parameter DIGGING = 2'b11;

	reg [1:0] state, next_state;
	reg [6:0] fall_counter;
	reg walk_left_r, walk_right_r, aaah_r, digging_r;

	always @(posedge clk or posedge areset) begin
		if (areset) begin
			state <= WALK_LEFT;
			fall_counter <= 0;
			walk_left_r <= 1;
			walk_right_r <= 0;
			aaah_r <= 0;
			digging_r <= 0;
		end else begin
			state <= next_state;
			if (next_state == FALLING) begin
				fall_counter <= fall_counter + 1;
			end else begin
				fall_counter <= 0;
			end

			case (next_state)
				WALK_LEFT: begin
					walk_left_r <= 1;
					walk_right_r <= 0;
					aaah_r <= 0;
					digging_r <= dig && ground;
				end
				WALK_RIGHT: begin
					walk_left_r <= 0;
					walk_right_r <= 1;
					aaah_r <= 0;
					digging_r <= dig && ground;
				end
				FALLING: begin
					walk_left_r <= 0;
					walk_right_r <= 0;
					aaah_r <= 1;
					digging_r <= 0;
				end
				DIGGING: begin
					walk_left_r <= 0;
					walk_right_r <= 0;
					aaah_r <= 0;
					digging_r <= 1;
				end
				default: begin
					walk_left_r <= 0;
					walk_right_r <= 0;
					aaah_r <= 0;
					digging_r <= 0;
				end
			endcase
		end
	end

	always @(*) begin
		next_state = state;
		case (state)
			WALK_LEFT: begin
				if (!ground)
					next_state = FALLING;
				else if (dig && ground)
					next_state = DIGGING;
				else if (bump_right)
					next_state = WALK_RIGHT;

			end
			WALK_RIGHT: begin
				if (!ground)
					next_state = FALLING;
				else if (dig && ground)
					next_state = DIGGING;
				else if (bump_left)
					next_state = WALK_LEFT;

			end
			FALLING: begin
				if (ground) begin
					if (fall_counter > 20)
						next_state = state; //splatter
					else
						next_state = (walk_left_r) ? WALK_LEFT : WALK_RIGHT;
				end

			end
			DIGGING: begin
				if (!ground)
					next_state = FALLING;
			end
			default: next_state = WALK_LEFT;
		endcase
	end

	assign walk_left = walk_left_r && (state != WALK_LEFT ||(state == WALK_LEFT && fall_counter <= 20 && ground) || (state == WALK_LEFT && dig && ground == 1) );
	assign walk_right = walk_right_r && (state != WALK_RIGHT ||(state == WALK_RIGHT && fall_counter <= 20 && ground) || (state == WALK_RIGHT && dig && ground == 1));
	assign aaah = aaah_r;
	assign digging = digging_r;

endmodule