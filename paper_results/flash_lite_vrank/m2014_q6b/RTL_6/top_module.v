module top_module(
	input [3:1] y,
	input w,
	output reg Y2);

  always @(*) begin
    case (y)
      3'b000: // A
        Y2 = (w == 1) ? 1'b0 : 1'b0; // next state: A (0) -> 000, A (1) -> 000
      3'b001: // B
        Y2 = (w == 1) ? 1'b1 : 1'b1; // next state: B (0) -> 101, B (1) -> 000
      3'b010: // C
        Y2 = (w == 1) ? 1'b1 : 1'b1; // next state: C (0) -> 101, C (1) -> 101
      3'b011: // D
        Y2 = (w == 1) ? 1'b0 : 1'b0; // next state: D (0) -> 000, D (1) -> 000
      3'b100: // E
        Y2 = (w == 1) ? 1'b1 : 1'b0; // next state: E (0) -> 101, E (1) -> 001
      3'b101: // F
        Y2 = (w == 1) ? 1'b1 : 1'b0; // next state: F (0) -> 101, F (1) -> 001
      default:
        Y2 = 1'b0;
    endcase
  end
endmodule