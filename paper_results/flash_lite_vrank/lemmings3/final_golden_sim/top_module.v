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

	parameter WALKING = 2'b00;
	parameter FALLING = 2'b01;
	parameter DIGGING = 2'b10;

	reg [1:0] state, next_state;
	reg walk_left_r, walk_right_r, aaah_r, digging_r;
	reg walk_direction; // 0: left, 1: right

	always @(posedge clk or posedge areset) begin
		if (areset) begin
			state <= WALKING;
			walk_left_r <= 1'b1;
			walk_right_r <= 1'b0;
			aaah_r <= 1'b0;
			digging_r <= 1'b0;
			walk_direction <= 1'b0;
		end else begin
			state <= next_state;
			walk_left_r <= (next_state == WALKING && !walk_direction) || (next_state == FALLING && !walk_direction) ;
			walk_right_r <= (next_state == WALKING && walk_direction) || (next_state == FALLING && walk_direction);
			aaah_r <= (next_state == FALLING);
			digging_r <= (next_state == DIGGING);
		end
	end

	always @(*) begin
		next_state = state;

		case (state)
			WALKING: begin
				if (!ground) begin
					next_state = FALLING;
				end else if (dig && ground) begin
					next_state = DIGGING;
				end else if (bump_left && !bump_right) begin
					walk_direction = 1'b1;
				end else if (bump_right && !bump_left) begin
					walk_direction = 1'b0;
				end else if (bump_left && bump_right) begin
					walk_direction = ~walk_direction;
				end
			end

			FALLING: begin
				if (ground) begin
					next_state = WALKING;
				end
			end

			DIGGING: begin
				if (!ground) begin
					next_state = FALLING;
				end
			end

			default: next_state = WALKING;
		endcase
	end

	assign walk_left = walk_left_r;
	assign walk_right = walk_right_r;
	assign aaah = aaah_r;
	assign digging = digging_r;

endmodule