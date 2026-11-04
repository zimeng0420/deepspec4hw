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

	parameter WALKING_LEFT = 2'b00;
	parameter WALKING_RIGHT = 2'b01;
	parameter FALLING = 2'b10;
	parameter DIGGING = 2'b11;

	reg [1:0] state, next_state;
	reg walk_left_r, walk_right_r, aaah_r, digging_r;
	reg prev_ground;

	always @(posedge clk or posedge areset) begin
		if (areset) begin
			state <= WALKING_LEFT;
			walk_left_r <= 1'b1;
			walk_right_r <= 1'b0;
			aaah_r <= 1'b0;
			digging_r <= 1'b0;
			prev_ground <= 1'b1;
		end else begin
			state <= next_state;
			walk_left_r <= (next_state == WALKING_LEFT) || (next_state == DIGGING && walk_left_r);
			walk_right_r <= (next_state == WALKING_RIGHT) || (next_state == DIGGING && walk_right_r);
			aaah_r <= (next_state == FALLING);
			digging_r <= (next_state == DIGGING);
			prev_ground <= ground;
		end
	end

	always @(*) begin
		next_state = state;
		case (state)
			WALKING_LEFT: begin
				if (!ground) begin
					next_state = FALLING;
				end else if (dig && ground) begin
					next_state = DIGGING;
				end else if (bump_right) begin
					next_state = WALKING_RIGHT;
				end
			end
			WALKING_RIGHT: begin
				if (!ground) begin
					next_state = FALLING;
				end else if (dig && ground) begin
					next_state = DIGGING;
				end else if (bump_left) begin
					next_state = WALKING_LEFT;
				end
			end
			FALLING: begin
				if (ground) begin
					if (walk_left_r)
						next_state = WALKING_LEFT;
					else
						next_state = WALKING_RIGHT;
				end
			end
			DIGGING: begin
				if (!ground) begin
					next_state = FALLING;
				end
			end
			default: next_state = WALKING_LEFT;
		endcase
	end

	assign walk_left = walk_left_r;
	assign walk_right = walk_right_r;
	assign aaah = aaah_r;
	assign digging = digging_r;

endmodule