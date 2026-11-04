module top_module (
    input a,
    input b,
    input c,
    input d,
    output q
);

  wire xnor_ab;
  wire xor_cd;

  assign xnor_ab = ~(a ^ b); // a XNOR b
  assign xor_cd = c ^ d; // c XOR d
  assign q = ~(xnor_ab ^ xor_cd); //(a XNOR b) XNOR (c XOR d)

endmodule