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

	parameter IDLE = 2'b00;
	parameter WALK_LEFT = 2'b01;
	parameter WALK_RIGHT = 2'b10;
	parameter FALLING = 2'b11;

	reg [1:0] state, next_state;
	reg digging_reg;
	reg walk_left_reg, walk_right_reg, aaah_reg;

	always @(posedge clk or posedge areset) begin
		if (areset) begin
			state <= IDLE;
			digging_reg <= 1'b0;
			walk_left_reg <= 1'b1;
			walk_right_reg <= 1'b0;
			aaah_reg <= 1'b0;
		end else begin
			state <= next_state;
			aaah_reg <= 1'b0;
		end
	end

	always @(*) begin
		next_state = state;
		digging = digging_reg;
		walk_left = walk_left_reg;
		walk_right = walk_right_reg;

		case (state)
			IDLE: begin
				walk_left = 1'b1;
				walk_right = 1'b0;
				digging = 1'b0;
				if (ground == 1'b0) begin
					next_state = FALLING;
					aaah_reg = 1'b1;
				end else if (dig == 1'b1) begin
					digging = 1'b1;
					digging_reg = 1'b1;
				end
				else if (bump_left == 1'b1) begin
					next_state = WALK_RIGHT;
					walk_left = 1'b0;
					walk_right = 1'b1;
					walk_left_reg = 1'b0;
					walk_right_reg = 1'b1;
				end else if (bump_right == 1'b1) begin
					next_state = WALK_LEFT;
					walk_left = 1'b1;
					walk_right = 1'b0;
					walk_left_reg = 1'b1;
					walk_right_reg = 1'b0;
				end
			end

			WALK_LEFT: begin
				walk_left = 1'b1;
				walk_right = 1'b0;
				digging = 1'b0;

				if (ground == 1'b0) begin
					next_state = FALLING;
					aaah_reg = 1'b1;
				end
				else if (dig == 1'b1) begin
					digging = 1'b1;
					digging_reg = 1'b1;
				end
				else if (bump_right == 1'b1) begin
					next_state = WALK_RIGHT;
					walk_left = 1'b0;
					walk_right = 1'b1;
					walk_left_reg = 1'b0;
					walk_right_reg = 1'b1;
				end
			end

			WALK_RIGHT: begin
				walk_left = 1'b0;
				walk_right = 1'b1;
				digging = 1'b0;

				if (ground == 1'b0) begin
					next_state = FALLING;
					aaah_reg = 1'b1;
				end
				else if (dig == 1'b1) begin
					digging = 1'b1;
					digging_reg = 1'b1;
				end
				else if (bump_left == 1'b1) begin
					next_state = WALK_LEFT;
					walk_left = 1'b1;
					walk_right = 1'b0;
					walk_left_reg = 1'b1;
					walk_right_reg = 1'b0;
				end
			end

			FALLING: begin
				walk_left = walk_left_reg;
				walk_right = walk_right_reg;
				digging = 1'b0;
				aaah_reg = 1'b1;

				if (ground == 1'b1) begin
					next_state = walk_left_reg ? WALK_LEFT: WALK_RIGHT;
				end
			end
			
		endcase
	end

	always @(posedge clk) begin
		if (!areset) begin
			if (digging_reg == 1'b1 && ground == 1'b0)
				digging_reg <= 1'b0;
		end
	end

endmodule