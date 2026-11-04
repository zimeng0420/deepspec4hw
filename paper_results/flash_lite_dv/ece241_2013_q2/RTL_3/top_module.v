module top_module(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

  // SOP implementation
  assign out_sop = (~a & ~c & d) | (b & c & d) | (a & b & c & d);

  // POS implementation - derived from the simplified SOP implementation.  This is much simpler.
  assign out_pos = ~out_sop;

endmodule