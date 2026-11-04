module top_module(
    input [3:1] y,
    input w,
    output reg Y2
);

  always @(*) begin
    case (y[3:1])
      3'b000: // A
        Y2 = (w == 1'b1) ? 1'b0 : 1'b0; // A --1--> A, A --0--> B (001) so y2 remains 0
      3'b001: // B
        Y2 = (w == 1'b1) ? 1'b0 : 1'b0; // B --1--> D (011), B --0--> C (010), so y2 remains 0
      3'b010: // C
        Y2 = (w == 1'b1) ? 1'b1 : 1'b1; // C --1--> D (011), C --0--> E (100), so y2 changes to 1 if w=1
      3'b011: // D
        Y2 = (w == 1'b1) ? 1'b0 : 1'b1; // D --1--> A (000), D --0--> F (101), so y2 changes to 1 if w=0
      3'b100: // E
        Y2 = (w == 1'b1) ? 1'b0 : 1'b1; // E --1--> D (011), E --0--> E (100), so y2 changes to 0 if w=1
      3'b101: // F
        Y2 = (w == 1'b1) ? 1'b0 : 1'b1; // F --1--> D (011), F --0--> C (010), so y2 changes to 0 if w=1
      default:
        Y2 = 1'b0;
    endcase
  end

endmodule