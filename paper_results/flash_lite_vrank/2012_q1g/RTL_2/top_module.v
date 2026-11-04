module top_module (
	input [4:1] x,
	output logic f
);

  always_comb begin
    case (x[4:3])
      2'b00: f = (x[2:1] == 2'b00) || (x[2:1] == 2'b10);
      2'b01: f = 1'b0;
      2'b11: f = (x[2:1] != 2'b10);
      2'b10: f = (x[2:1] == 2'b00) || (x[2:1] == 2'b01) || (x[2:1] == 2'b10);
      default: f = 1'b0;
    endcase
  end
endmodule