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

	// Define states
	parameter IDLE = 2'b00; // Not falling, not digging, walking
	parameter FALLING = 2'b01;
	parameter DIGGING = 2'b10;

	// State register
	reg [1:0] state;

	// Default values
	always @(posedge clk or posedge areset) begin
		if (areset) begin
			state <= IDLE;
			walk_left <= 1;
			walk_right <= 0;
			aaah <= 0;
			digging <= 0;
		end else begin
			case (state)
				IDLE: begin
					aaah <= 0;
					digging <= 0;
					if (!ground) begin
						state <= FALLING;
					end else if (dig && ground) begin
						state <= DIGGING;
					end else if (bump_left) begin
						walk_left <= 0;
						walk_right <= 1;
					end else if (bump_right) begin
						walk_left <= 1;
						walk_right <= 0;
					end
				end
				FALLING: begin
					aaah <= 1;
					digging <= 0;
					walk_left <= walk_left; // Maintain direction
					walk_right <= walk_right;
					if (ground) begin
						state <= IDLE;
					end
				end
				DIGGING: begin
					aaah <= 0;
					digging <= 1;
					walk_left <= walk_left; // Maintain direction
					walk_right <= walk_right;
					if (!ground) begin
						state <= FALLING;
					end
				end
			endcase
		end
	end
endmodule