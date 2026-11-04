module top_module (
    input [4:1] x,
    output logic f
);

  // Simplified Boolean expression: f = x[3] | (x[3] & x[2])
  assign f = x[3] | (x[3] & x[2]);

endmodule