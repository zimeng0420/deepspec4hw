module top_module(
	input [3:1] y,
	input w,
	output reg Y2);

	always @(*) begin
		case (y)
			3'b000: // A
				Y2 = w ? 1'b0 : 1'b0; // A -> A or B
			3'b001: // B
				Y2 = w ? 1'b1 : 1'b0; // B -> D or C
			3'b010: // C
				Y2 = w ? 1'b1 : 1'b0; // C -> D or E
			3'b011: // D
				Y2 = w ? 1'b0 : 1'b1; // D -> A or F
			3'b100: // E
				Y2 = w ? 1'b1 : 1'b0; // E -> D or E
			3'b101: // F
				Y2 = w ? 1'b1 : 1'b0; // F -> D or C
			default:
				Y2 = 1'b0;
		endcase
	end
endmodule