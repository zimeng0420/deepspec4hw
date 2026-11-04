module top_module(
	input [3:1] y,
	input w,
	output reg Y2);

	always @(*) begin
		case (y)
			3'b000: // A
				Y2 = (w == 1'b1) ? 1'b0 : 1'b0;
			3'b001: // B
				Y2 = (w == 1'b1) ? 1'b1 : 1'b0;
			3'b010: // C
				Y2 = (w == 1'b1) ? 1'b1 : 1'b0;
			3'b011: // D
				Y2 = (w == 1'b1) ? 1'b0 : 1'b1;
			3'b100: // E
				Y2 = (w == 1'b1) ? 1'b1 : 1'b0;
			3'b101: // F
				Y2 = (w == 1'b1) ? 1'b1 : 1'b0;
			default:
				Y2 = 1'b0; // Default state (should not happen)
		endcase
	end
endmodule