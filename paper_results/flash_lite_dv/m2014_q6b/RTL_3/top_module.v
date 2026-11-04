module top_module(
    input [2:0] y,
    input w,
    output reg Y2
);

  always @(*) begin
    case (y)
      3'b000: // A
        Y2 = w ? 1'b0 : 1'b0; // A --1--> A, A --0--> B (001), so Y2 does not change
      3'b001: // B
        Y2 = w ? 1'b1 : 1'b0; // B --1--> D(011), B --0--> C(010), so Y2 changes with w
      3'b010: // C
        Y2 = w ? 1'b1 : 1'b0; // C --1--> D(011), C --0--> E(100), so Y2 changes with w
      3'b011: // D
        Y2 = w ? 1'b0 : 1'b0; // D --1--> A(000), D --0--> F(101), so Y2 changes with w
      3'b100: // E
        Y2 = w ? 1'b1 : 1'b0; // E --1--> D(011), E --0--> E(100), so Y2 changes with w
      3'b101: // F
        Y2 = w ? 1'b1 : 1'b0; // F --1--> D(011), F --0--> C(010), so Y2 changes with w
      default:
        Y2 = 1'b0;
    endcase
  end

endmodule