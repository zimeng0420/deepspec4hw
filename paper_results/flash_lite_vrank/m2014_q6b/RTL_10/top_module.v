module top_module(
	input [3:1] y,
	input w,
	output reg Y2
);

  always @(*) begin
    case (y)
      3'b000: // A
        Y2 = w; // if w=1, go to A (000) -> y2=0; if w=0, go to B (001) -> y2=0
      3'b001: // B
        Y2 = w; // if w=1, go to D (100) -> y2=0; if w=0, go to C (010) -> y2=0
      3'b010: // C
        Y2 = w; // if w=1, go to D (100) -> y2=0; if w=0, go to E (101) -> y2=1
      3'b100: // D
        Y2 = ~w; // if w=1, go to A (000) -> y2=0; if w=0, go to F (110) -> y2=1
      3'b101: // E
        Y2 = w; // if w=1, go to D (100) -> y2=0; if w=0, go to E (101) -> y2=1
      3'b110: // F - Not defined as per prompt, using F as dummy state
        Y2 = w; // if w=1, go to D (100) -> y2=0; if w=0, go to C (010) -> y2=0
      default:
        Y2 = 1'b0; // Default state (error state)
    endcase
  end
endmodule