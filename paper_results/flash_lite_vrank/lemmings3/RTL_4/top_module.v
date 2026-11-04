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
	parameter DIGGING = 2'b11;

	reg [1:0] state, next_state;
	reg walk_left_r, walk_right_r, aaah_r, digging_r;

	always @(posedge clk or posedge areset) begin
		if (areset) begin
			state <= IDLE;
			walk_left_r <= 1'b1;
			walk_right_r <= 1'b0;
			aaah_r <= 1'b0;
			digging_r <= 1'b0;
		end else begin
			state <= next_state;
			walk_left_r <= walk_left;
			walk_right_r <= walk_right;
			aaah_r <= aaah;
			digging_r <= digging;
		end
	end

	always @(*) begin
		next_state = state;
		walk_left = walk_left_r;
		walk_right = walk_right_r;
		aaah = 1'b0;
		digging = 1'b0;

		case (state)
			IDLE: begin
				walk_left = 1'b1;
				walk_right = 1'b0;
				if (ground) begin
					next_state = WALK_LEFT;
				end else begin
					aaah = 1'b1;
				end

			end
			WALK_LEFT: begin
				if (!ground) begin
					aaah = 1'b1;
					next_state = IDLE;
				end else if (bump_right) begin
					walk_left = 1'b0;
					walk_right = 1'b1;
					next_state = WALK_RIGHT;
				end else if (dig && ground) begin
					digging = 1'b1;
					next_state = DIGGING;
				end

			end
			WALK_RIGHT: begin
				if (!ground) begin
					aaah = 1'b1;
					next_state = IDLE;
				end else if (bump_left) begin
					walk_left = 1'b1;
					walk_right = 1'b0;
					next_state = WALK_LEFT;
				end else if (dig && ground) begin
					digging = 1'b1;
					next_state = DIGGING;
				end

			end
			DIGGING: begin
				digging = 1'b1;
				if (!ground) begin
					aaah = 1'b1;
					next_state = IDLE;

				end else if (walk_left_r) begin
					walk_left = 1'b1;
					walk_right = 1'b0;
					next_state = WALK_LEFT;

				end else begin
					walk_left = 1'b0;
					walk_right = 1'b1;
					next_state = WALK_RIGHT;
				end
			end
			default: begin
				walk_left = 1'b1;
				walk_right = 1'b0;
				next_state = WALK_LEFT;
			end
		endcase
	end
endmodule