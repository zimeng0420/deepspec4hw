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
	parameter SPLATTERED = 2'b11;

	reg [1:0] state;
	reg [1:0] next_state;
	reg [5:0] fall_counter;
	reg walk_direction; // 0: left, 1: right

	always @(*) begin
		next_state = state;
		walk_left = 0;
		walk_right = 0;
		aaah = 0;
		digging = 0;

		case (state)
			WALKING: begin
				if (!ground) begin
					next_state = FALLING;
					fall_counter = 0;
					aaah = 1;
				end else if (dig) begin
					next_state = DIGGING;
					digging = 1;
				end else if (bump_left && !bump_right) begin
					walk_direction = 1; // Switch to right
				end else if (bump_right && !bump_left) begin
					walk_direction = 0; // Switch to left
				end else if (bump_left && bump_right) begin
					walk_direction = ~walk_direction;
				end
                
				if (walk_direction == 0) begin
					walk_left = 1;
				end else begin
					walk_right = 1;
				end
			end
			
			FALLING: begin
				aaah = 1;
				fall_counter = fall_counter + 1;
				if (ground) begin
					if (fall_counter > 20) {
						next_state = SPLATTERED;
					} else {
						next_state = WALKING;
					}
				end
			end

			DIGGING: begin
				digging = 1;
				if (!ground) begin
					next_state = FALLING;
					fall_counter = 0;
					aaah = 1;
				end
                if (walk_direction == 0) begin
					walk_left = 1;
				end else begin
					walk_right = 1;
				end
			end

			SPLATTERED: begin
				// All outputs are already 0 by default
			end
		endcase
	end

	always @(posedge clk or posedge areset) begin
		if (areset) begin
			state <= WALKING;
			walk_direction <= 0; // Default direction: left
			fall_counter <= 0;
		end else begin
			state <= next_state;
		end
	end

endmodule