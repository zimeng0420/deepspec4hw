module top_module (
	input clk,
	input areset,
	input bump_left,
	input bump_right,
	output walk_left,
	output walk_right
);

	parameter WALK_LEFT_STATE = 0;
	parameter WALK_RIGHT_STATE = 1;

	reg [0:0] state, next_state;

	always @(posedge clk or posedge areset) begin
		if (areset)
			state <= WALK_LEFT_STATE;
		else
			state <= next_state;
	end

	always @(*) begin
		case (state)
			WALK_LEFT_STATE:
				if (bump_left)
					next_state = WALK_RIGHT_STATE;
				else
					next_state = WALK_LEFT_STATE;
			WALK_RIGHT_STATE:
				if (bump_right)
					next_state = WALK_LEFT_STATE;
				else
					next_state = WALK_RIGHT_STATE;
			default:
				next_state = WALK_LEFT_STATE;
		endcase
	end

	assign walk_left = (state == WALK_LEFT_STATE);
	assign walk_right = (state == WALK_RIGHT_STATE);

endmodule