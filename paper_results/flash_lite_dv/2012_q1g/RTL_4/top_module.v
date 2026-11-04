module top_module(
    input [3:1] x,
    output f
);

  assign f = (~x[4] & ~x[3] & ~x[2]) | (x[4] & x[3]) | (x[4] & ~x[3] & ~x[2]);

endmodule