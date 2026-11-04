module top_module(
    input [3:1] y,
    input w,
    output reg Y2
);

  always @(*) begin
    case (y[3:1])
      3'b000: // A
        Y2 = 1'b0; // A --0--> B, A --1--> A
      3'b001: // B
        Y2 = 1'b0; // B --0--> C, B --1--> D
      3'b010: // C
        Y2 = (w) ? 1'b1 : 1'b0; // C --0--> E, C --1--> D
      3'b011: // D
        Y2 = 1'b0; // D --0--> F, D --1--> A
      3'b100: // E
        Y2 = (w) ? 1'b1 : 1'b0; // E --0--> E, E --1--> D
      3'b101: // F
        Y2 = (w) ? 1'b1 : 1'b0; // F --0--> C, F --1--> D
      default:
        Y2 = 1'b0; // Default state
    endcase
  end

endmodule