module top_module(
    input a,
    input b,
    input c,
    input d,
    output out
);

  // Simplified Boolean expression derived from the Karnaugh map:
  // out = (a & c) | (a & d) | (b & c) | (b & d)

  assign out = (a & c) | (a & d) | (b & c) | (b & d);

endmodule