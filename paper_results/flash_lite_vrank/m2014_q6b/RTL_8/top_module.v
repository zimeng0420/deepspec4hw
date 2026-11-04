module top_module(
	input [3:1] y,
	input w,
	output reg Y2);

	always @(*) begin
		case (y)
			3'b000: // A
				Y2 = w;  // A --1--> A, A --0--> B
			3'b001: // B
				Y2 = w; // B --1--> D, B --0--> C
			3'b010: // C
				Y2 = w; // C --1--> D, C --0--> E
			3'b011: // D
				Y2 = ~w; // D --1--> A, D --0--> F
			3'b100: // E
				Y2 = w; // E --1--> D, E --0--> E
			3'b101: // F
				Y2 = ~w; // F --1--> D, F --0--> C
			default:
				Y2 = 1'b0;
		endcase
	end
endmodule