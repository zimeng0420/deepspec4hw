module top_module(
	input [3:1] y,
	input w,
	output reg Y2);

	always @(*) begin
		case (y)
			3'b000: // A
				Y2 = w;  // if w = 1 -> D (101), otherwise B (001)
			3'b001: // B
				Y2 = y[1] & w;  // if w = 1 -> D (101), otherwise C (010)
			3'b010: // C
				Y2 = y[1] | w;  // if w = 1 -> D (101), otherwise E (100)
			3'b011: // D
				Y2 = w;   // if w = 1 -> A (000), otherwise F (101)
			3'b100: // E
				Y2 = w; // if w = 1 -> D (011), otherwise E (100)
			3'b101: // F
				Y2 = ~w;  // if w = 1 -> D (011), otherwise C (010)
			default:
				Y2 = 1'b0;
		endcase
	end
endmodule