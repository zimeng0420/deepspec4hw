module top_module(
    input x1,
    input x2,
    input x3,
    output f
);

  // Simplified Boolean expression: f = (x2 & x1) | (x3 & x1) | (x2 & !x3)
  assign f = (x2 & x1) | (x3 & x1) | (x2 & ~x3);

endmodule