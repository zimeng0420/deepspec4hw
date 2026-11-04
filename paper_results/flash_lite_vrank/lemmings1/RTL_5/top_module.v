module top_module (
	input clk,
	input areset,
	input bump_left,
	input bump_right,
	output walk_left,
	output walk_right
);

	parameter LEFT = 0;
	parameter RIGHT = 1;

	reg [0:0] state;

	always @(posedge clk or posedge areset) begin
		if (areset)
			state <= LEFT;
		else begin
			case (state)
				LEFT:
					if (bump_left)
						state <= RIGHT;
					else
						state <= LEFT;
				RIGHT:
					if (bump_right)
						state <= LEFT;
					else
						state <= RIGHT;
			endcase
		end
	end

	assign walk_left = (state == LEFT);
	assign walk_right = (state == RIGHT);

endmodule