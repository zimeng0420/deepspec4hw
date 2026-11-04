module top_module (
	input [4:1] x,
	output logic f
);

  always_comb begin
    case (x[4:3])
      2'b00: begin
        case (x[2:1])
          2'b00: f = 1'b1;
          2'b01: f = 1'b0;
          2'b11: f = 1'b0;
          2'b10: f = 1'b1;
        endcase
      end
      2'b01: begin
        f = 1'b0;
      end
      2'b11: begin
        case (x[2:1])
          2'b00: f = 1'b1;
          2'b01: f = 1'b1;
          2'b11: f = 1'b1;
          2'b10: f = 1'b0;
        endcase
      end
      2'b10: begin
        case (x[2:1])
          2'b00: f = 1'b1;
          2'b01: f = 1'b1;
          2'b11: f = 1'b0;
          2'b10: f = 1'b1;
        endcase
      end
    endcase
  end
endmodule