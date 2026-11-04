module top_module(
  input [3:1] y,
  input w,
  output reg Y2
);

  always @(*) begin
    case (y)
      4'b000:  // State A
        Y2 = 0; // A --0--> B, A --1--> A
      4'b001:  // State B
        Y2 = 0; // B --0--> C, B --1--> D
      4'b010:  // State C
        Y2 = 0; // C --0--> E, C --1--> D
      4'b011:  // State D
        Y2 = 0; // D --0--> F, D --1--> A
      4'b100:  // State E
        Y2 = 0; // E --0--> E, E --1--> D
      4'b101:  // State F
        Y2 = 0; // F --0--> C, F --1--> D
      default:
        Y2 = 0;
    endcase
  end

endmodule