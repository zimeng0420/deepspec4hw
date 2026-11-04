module top_module (
    input a,
    input b,
    input c,
    input d,
    output out
);

  wire not_a;
  wire not_b;
  wire not_c;
  wire not_d;
  wire term1;
  wire term2;
  wire term3;
  wire term4;

  assign not_a = ~a;
  assign not_b = ~b;
  assign not_c = ~c;
  assign not_d = ~d;

  assign term1 = not_a & not_c;
  assign term2 = a & b & d;
  assign term3 = not_b & not_c & not_d;
  assign term4 = b & c & d;

  assign out = term1 | term2 | term3 | term4;

endmodule