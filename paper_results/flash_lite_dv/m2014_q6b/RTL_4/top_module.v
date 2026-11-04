module top_module(
    input [2:0] y,
    input w,
    output reg Y2
);

  always @(*) begin
    case (y)
      3'b000: begin // A
        Y2 = (w == 1'b1) ? 1'b0 : 1'b0; // A --1--> A, A --0--> B
      end
      3'b001: begin // B
        Y2 = (w == 1'b1) ? 1'b1 : 1'b0; // B --1--> D, B --0--> C
      end
      3'b010: begin // C
        Y2 = (w == 1'b1) ? 1'b1 : 1'b1; // C --1--> D, C --0--> E
      end
      3'b011: begin // D
        Y2 = (w == 1'b1) ? 1'b0 : 1'b1; // D --1--> A, D --0--> F
      end
      3'b100: begin // E
        Y2 = (w == 1'b1) ? 1'b1 : 1'b1; // E --1--> D, E --0--> E
      end
      3'b101: begin // F
        Y2 = (w == 1'b1) ? 1'b1 : 1'b1; // F --1--> D, F --0--> C
      end
      default: Y2 = 1'b0;
    endcase
  end
endmodule