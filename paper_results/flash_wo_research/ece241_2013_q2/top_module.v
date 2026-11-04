module top_module (
	input a,
	input b,
	input c,
	input d,
	output out_sop,
	output out_pos
);

  // SOP: out_sop = (!a & !b & c & !d) | (b & c & d) | (a & b & c & d)
  assign out_sop = (~a & ~b & c & ~d) | (b & c & d) | (a & b & c & d);

  // POS: out_pos = (!a) & (c | d)
  assign out_pos = (~a) & (c | d);

endmodule