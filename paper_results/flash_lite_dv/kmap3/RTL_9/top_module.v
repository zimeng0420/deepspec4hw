module top_module(
    input a,
    input b,
    input c,
    input d,
    output out
);

  // Simplified Boolean expression derived from the Karnaugh map:
  // out = (b & a) | (a & c) | (a & d) | (b & c & ~d)
  // OR
  // out = a & (b | c | d)

  assign out = a & (b | c | d);

endmodule