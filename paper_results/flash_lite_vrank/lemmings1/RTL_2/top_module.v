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

	reg [1:0] state;
	
	always @(posedge clk or posedge areset) begin
		if (areset) begin
			state <= WALK_LEFT;
		end else begin
			case (state)
				WALK_LEFT: begin
					if (bump_left) begin
						state <= WALK_RIGHT;
					end else if (bump_right) begin
						state <= WALK_RIGHT;
					end
				end
				WALK_RIGHT: begin
					if (bump_left) begin
						state <= WALK_LEFT;
					end else if (bump_right) begin
						state <= WALK_LEFT;
					end
				end
				default: state <= WALK_LEFT;
			endcase
		end
	end

	always @(*) begin
		case (state)
			WALK_LEFT: begin
				walk_left = 1;
				walk_right = 0;
			end
			WALK_RIGHT: begin
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