module top_module (
	input [15:0] scancode,
	output reg left,
	output reg down,
	output reg right,
	output reg up
);

	always @(*) begin
		case (scancode)
			16'he06b: begin // Left arrow
				left = 1'b1;
				down = 1'b0;
				right = 1'b0;
				up = 1'b0;
			end
			16'he072: begin // Down arrow
				left = 1'b0;
				down = 1'b1;
				right = 1'b0;
				up = 1'b0;
			end
			16'he074: begin // Right arrow
				left = 1'b0;
				down = 1'b0;
				right = 1'b1;
				up = 1'b0;
			end
			16'he075: begin // Up arrow
				left = 1'b0;
				down = 1'b0;
				right = 1'b0;
				up = 1'b1;
			end
			default: begin // None of the arrow keys
				left = 1'b0;
				down = 1'b0;
				right = 1'b0;
				up = 1'b0;
			end
		endcase
	end

endmodule