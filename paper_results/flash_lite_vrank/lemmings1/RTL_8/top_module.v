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

	reg [1:0] state;

	always @(posedge clk or posedge areset) begin
		if (areset) begin
			state <= LEFT;
		end else begin
			case (state)
				LEFT: begin
					if (bump_left)
						state <= RIGHT;
				end
				RIGHT: begin
					if (bump_right)
						state <= LEFT;
				end
			endcase
		end
	end

	always @(*) begin
		case (state)
			LEFT: begin
				walk_left = 1;
				walk_right = 0;
			end
			RIGHT: begin
				walk_left = 0;
				walk_right = 1;
			end
			default: begin
				walk_left = 1;
				walk_right = 0;
			end
		endcase
	end
endmodule