module top_module(
    input  [1:4] x,
    output f
);

  wire x3_n, x4_n, x2_n;

  assign x3_n = ~x[3];
  assign x4_n = ~x[4];
  assign x2_n = ~x[2];

  assign f = (x4_n & x3_n & x2_n) | (x[4] & x[3]) | (x[4] & x3_n & x2_n);

endmodule