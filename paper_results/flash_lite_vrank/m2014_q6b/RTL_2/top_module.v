module top_module(
	input [3:1] y,
	input w,
	output reg Y2
);

  always @(*) begin
    case (y)
      3'b000: // A
        Y2 = w;  // Next state is B (001) if w=0, A (000) if w=1, so y2 = w.
      3'b001: // B
        Y2 = y[3] | w; // Next state is C (010) if w=0, D (011) if w=1, so y2 = w
      3'b010: // C
        Y2 = w; // Next state is E (100) if w=0, D (011) if w=1, so y2 = w
      3'b011: // D
        Y2 = !w; // Next state is F (101) if w=0, A (000) if w=1, so y2 = !w
      3'b100: // E
        Y2 = !w; // Next state is E (100) if w=0, D (011) if w=1, so y2 = !w
      3'b101: // F
        Y2 = !w; // Next state is C (010) if w=0, D (011) if w=1, so y2 = !w
      default:
        Y2 = 1'b0; // Default state, should not occur.
    endcase
  end

endmodule