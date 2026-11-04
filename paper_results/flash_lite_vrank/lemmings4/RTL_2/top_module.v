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
	reg walk_left_r, walk_right_r, aaah_r, digging_r;
	
	always @(posedge clk or posedge areset) begin
		if (areset) begin
			state <= S_WALK_LEFT;
			fall_counter <= 6'b0;
			walk_left_r <= 1'b1;
			walk_right_r <= 1'b0;
			aaah_r <= 1'b0;
			digging_r <= 1'b0;
		end else begin
			state <= next_state;
			if (next_state == S_FALL) begin
				fall_counter <= fall_counter + 1'b1;
			end else begin
				fall_counter <= 6'b0;
			end
			
			if (state == S_WALK_LEFT) begin
				walk_left_r <= 1'b1;
				walk_right_r <= 1'b0;
			end else if (state == S_WALK_RIGHT) begin
				walk_left_r <= 1'b0;
				walk_right_r <= 1'b1;
			end else if (state == S_FALL) begin
				walk_left_r <= 1'b0;
				walk_right_r <= 1'b0;
			end else if (state == S_DIG) begin
				walk_left_r <= walk_left_r;
				walk_right_r <= walk_right_r;
			end
			
			aaah_r <= (state == S_FALL);
			digging_r <= (state == S_DIG);
		end
	end
	
	always @(*) begin
		next_state = state;
		case (state)
			S_WALK_LEFT: begin
				if (!ground) begin
					next_state = S_FALL;
				end else if (dig) begin
					next_state = S_DIG;
				end else if (bump_right) begin
					next_state = S_WALK_RIGHT;
				end
			end
			S_WALK_RIGHT: begin
				if (!ground) begin
					next_state = S_FALL;
				end else if (dig) begin
					next_state = S_DIG;
				end else if (bump_left) begin
					next_state = S_WALK_LEFT;
				end
			end
			S_FALL: begin
				if (ground) begin
					if (fall_counter > 20) begin
						next_state = state; // splat, stay in current state (all outputs 0)
					end else if (walk_left_r) begin
						next_state = S_WALK_LEFT;
					end else begin
						next_state = S_WALK_RIGHT;
					end
				end
			end
			S_DIG: begin
				if (!ground) begin
					next_state = S_FALL;
				end
			end
			default: next_state = S_WALK_LEFT;
		endcase
	end

	assign walk_left = (fall_counter > 20) ? 1'b0 : walk_left_r;
	assign walk_right = (fall_counter > 20) ? 1'b0 : walk_right_r;
	assign aaah = (fall_counter > 20) ? 1'b0 : aaah_r;
	assign digging = (fall_counter > 20) ? 1'b0 : digging_r;
	
endmodule