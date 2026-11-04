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
	reg [5:0] fall_counter;
	reg [1:0] walk_dir; // 00: left, 01: right

	always @(posedge clk or posedge areset) begin
		if (areset) begin
			state <= S_WALK_LEFT;
			fall_counter <= 6'b0;
			walk_dir <= 2'b00; // Start walking left
		end else begin
			state <= next_state;
			if (next_state == S_FALL) begin
				if (ground) begin
					fall_counter <= (fall_counter > 20) ? 6'b0 : fall_counter;  // Splatter check
				end else begin
					fall_counter <= fall_counter + 1'b1;
				end
			end else begin
				fall_counter <= 6'b0;
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
			S_WALK_LEFT: begin
				walk_left = 1;
				walk_dir = 2'b00;
				if (!ground) begin
					next_state = S_FALL;
				end else if (dig) begin
					next_state = S_DIG;
				end else if (bump_right) begin
					next_state = S_WALK_RIGHT;
				end
			end
			S_WALK_RIGHT: begin
				walk_right = 1;
				walk_dir = 2'b01;
				if (!ground) begin
					next_state = S_FALL;
				end else if (dig) begin
					next_state = S_DIG;
				end else if (bump_left) begin
					next_state = S_WALK_LEFT;
				end
			end
			S_FALL: begin
				aaah = 1;
				if (ground) begin
					if (fall_counter > 20) begin
						next_state = state; //splatter, stay in same state
						walk_left = 0;
						walk_right = 0;
						aaah = 0;
						digging = 0;
					end else begin
						if(walk_dir == 2'b00)
							next_state = S_WALK_LEFT;
						else
							next_state = S_WALK_RIGHT;
					end
				end
			end
			S_DIG: begin
				digging = 1;
				if (!ground) begin
					next_state = S_FALL;
				end
				else begin
					if (walk_dir == 2'b00)
					    walk_left =1;
					else
					    walk_right = 1;
				end

			end
		endcase
	end

endmodule