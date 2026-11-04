module top_module (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

  // SOP Implementation
  assign out_sop = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d);

  // POS Implementation - Alternative, Inverted SOP
  assign out_pos = ~out_sop;

endmodule