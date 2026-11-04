module top_module (
	input clk,
	input areset,
	input bump_left,
	input bump_right,
	output walk_left,
	output walk_right
);

	parameter WALK_LEFT = 0;
	parameter WALK_RIGHT = 1;

	reg [0:0] state;

	always @(posedge clk or posedge areset) begin
		if (areset)
			state <= WALK_LEFT;
		else begin
			case (state)
				WALK_LEFT:
					if (bump_left)
						state <= WALK_RIGHT;
					else if (bump_right)
						state <= WALK_RIGHT;
					else
						state <= WALK_LEFT;
				WALK_RIGHT:
					if (bump_left)
						state <= WALK_LEFT;
					else if (bump_right)
						state <= WALK_LEFT;
					else
						state <= WALK_RIGHT;
			endcase
		end
	end

	assign walk_left = (state == WALK_LEFT) ? 1 : 0;
	assign walk_right = (state == WALK_RIGHT) ? 1 : 0;

endmodule