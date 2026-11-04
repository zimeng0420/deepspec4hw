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
	parameter FALLING = 3;
	parameter DIGGING = 4;
	parameter SPLATTER = 5;

	reg [2:0] state, next_state;
	reg [5:0] fall_counter;
	reg walk_dir; // 0: left, 1: right

	always @(posedge clk or posedge areset) begin
		if (areset) begin
			state <= IDLE;
			fall_counter <= 0;
		end else begin
			state <= next_state;
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
				walk_left = 1;
				walk_dir = 0; // initialize
				next_state = WALK_LEFT;
			end
			WALK_LEFT: begin
				walk_left = 1;
				fall_counter = 0;
				if (!ground) begin
					next_state = FALLING;
					aaah = 1;
				end else if (bump_right) begin
					next_state = WALK_RIGHT;
					walk_dir = 1;
				end else if (dig && ground) begin
					next_state = DIGGING;
					digging = 1;
				end
			end
			WALK_RIGHT: begin
				walk_right = 1;
				fall_counter = 0;
				if (!ground) begin
					next_state = FALLING;
					aaah = 1;
				end else if (bump_left) begin
					next_state = WALK_LEFT;
					walk_dir = 0;
				end else if (dig && ground) begin
					next_state = DIGGING;
					digging = 1;
				end
			end
			FALLING: begin
				aaah = 1;
				if (ground) begin
					if (fall_counter > 20) begin
						next_state = SPLATTER;
					end else begin
						if (walk_dir == 0) begin
							next_state = WALK_LEFT;
							walk_left = 1;
						end else begin
							next_state = WALK_RIGHT;
							walk_right = 1;
						end
					end
				end else begin
					fall_counter = fall_counter + 1;
				end
			end
			DIGGING: begin
				digging = 1;
				fall_counter = 0;
				if (!ground) begin
					next_state = FALLING;
					aaah = 1;
				end else if (walk_dir == 0) begin
					walk_left = 1;
					next_state = WALK_LEFT;
				end else begin
					walk_right = 1;
					next_state = WALK_RIGHT;
				end
			end
			SPLATTER: begin
				walk_left = 0;
				walk_right = 0;
				aaah = 0;
				digging = 0;
				next_state = SPLATTER;
			end
			default: begin
				walk_left = 1; //default to walk left
				walk_dir = 0;
				next_state = WALK_LEFT;
			end
		endcase
	end

endmodule