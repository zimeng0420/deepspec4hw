module top_module (
	input clk,
	input areset,
	input bump_left,
	input bump_right,
	input ground,
	output walk_left,
	output walk_right,
	output aaah
);

	// Define states
	parameter WALKING_LEFT = 2'b00;
	parameter WALKING_RIGHT = 2'b01;
	parameter FALLING_LEFT = 2'b10;
	parameter FALLING_RIGHT = 2'b11;

	// State register
	reg [1:0] current_state, next_state;

	// Output register
	reg walk_left_reg, walk_right_reg, aaah_reg;


	// State transition logic
	always @(*) begin
		next_state = current_state;
		case (current_state)
			WALKING_LEFT: begin
				if (ground == 0)
					next_state = FALLING_LEFT;
				else if (bump_right)
					next_state = WALKING_RIGHT;
			end
			WALKING_RIGHT: begin
				if (ground == 0)
					next_state = FALLING_RIGHT;
				else if (bump_left)
					next_state = WALKING_LEFT;
			end
			FALLING_LEFT: begin
				if (ground == 1)
					next_state = WALKING_LEFT;
			end
			FALLING_RIGHT: begin
				if (ground == 1)
					next_state = WALKING_RIGHT;
			end
			default: next_state = WALKING_LEFT;
		endcase
	end

	// Output logic
	always @(*) begin
		walk_left_reg = 0;
		walk_right_reg = 0;
		aaah_reg = 0;

		case (current_state)
			WALKING_LEFT: begin
				walk_left_reg = 1;
			end
			WALKING_RIGHT: begin
				walk_right_reg = 1;
			end
			FALLING_LEFT: begin
				walk_left_reg = 1;
				aaah_reg = 1;
			end
			FALLING_RIGHT: begin
				walk_right_reg = 1;
				aaah_reg = 1;
			end
			default: ;
		endcase
	end


	// State register update
	always @(posedge clk or posedge areset) begin
		if (areset)
			current_state <= WALKING_LEFT;
		else
			current_state <= next_state;
	end

	// Output register update
	assign walk_left = walk_left_reg;
	assign walk_right = walk_right_reg;
	assign aaah = aaah_reg;

endmodule