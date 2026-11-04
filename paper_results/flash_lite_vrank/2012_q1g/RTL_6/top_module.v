module top_module (
	input [4:1] x,
	output logic f
);

  always_comb begin
    case (x[4:3])
      2'b00:
        f = (x[2] == 1'b0 && x[1] == 1'b0) || (x[2] == 1'b1 && x[1] == 1'b0);
      2'b01:
        f = 1'b0;
      2'b11:
        f = (x[2] == 1'b0) || (x[1] == 1'b0) || (x[2] == 1'b1 && x[1] == 1'b1);
      2'b10:
        f = (x[2] == 1'b0) || (x[1] == 1'b1) || (x[2] == 1'b1 && x[1] == 1'b0);
      default:
        f = 1'b0; // Should not happen, but good practice
    endcase
  end
endmodule