module top_module (
	input clk,
	input areset,
	input bump_left,
	input bump_right,
	input ground,
	input dig,
	output reg walk_left,
	output reg walk_right,
	output reg aaah,
	output reg digging
);

	reg [4:0] state, next_state;
	localparam [4:0] WALK_LEFT = 5'b00001,
					 WALK_RIGHT = 5'b00010,
					 FALLING = 5'b00100,
					 DIGGING = 5'b01000,
					 SPLATTER = 5'b10000;

	reg [4:0] fall_counter;

	always @(posedge clk or posedge areset) begin
		if (areset) begin
			state <= WALK_LEFT;
			fall_counter <= 0;
		end else begin
			state <= next_state;
			if (state == FALLING) begin
				fall_counter <= fall_counter + 1;
			end else if (ground) begin
				fall_counter <= 0;
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
			WALK_LEFT: begin
				if (!ground) begin
					next_state = FALLING;
					aaah = 1;
				end else if (dig) begin
					next_state = DIGGING;
					digging = 1;
				end else if (bump_right) begin
					next_state = WALK_RIGHT;
				end else begin
					walk_left = 1;
				end
			end
			WALK_RIGHT: begin
				if (!ground) begin
					next_state = FALLING;
					aaah = 1;
				end else if (dig) begin
					next_state = DIGGING;
					digging = 1;
				end else if (bump_left) begin
					next_state = WALK_LEFT;
				end else begin
					walk_right = 1;
				end
			end
			FALLING: begin
				aaah = 1;
				if (ground) begin
					if (fall_counter > 20) begin
						next_state = SPLATTER;
					end else if (state == FALLING) begin
						if (walk_left) next_state = WALK_LEFT;
						else if (walk_right) next_state = WALK_RIGHT;
					end
				end
			end
			DIGGING: begin
				if (!ground) begin
					next_state = FALLING;
					aaah = 1;
				end else if (bump_left || bump_right) begin
					// Do nothing while digging
				end else begin
					walk_left = 1;
				end
			end
			SPLATTER: begin
				walk_left = 0;
				walk_right = 0;
				aaah = 0;
				digging = 0;
			end
		endcase
	end

endmodule