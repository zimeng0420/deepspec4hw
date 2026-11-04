module top_module (
	input a,
	input b,
	input c,
	input d,
	output out_sop,
	output out_pos
);

  // SOP Implementation
  assign out_sop = (!a & c) | (!a & b & c & d) | (a & b & c & d);

  // POS Implementation
  assign out_pos = (c | !d) & (!a | !b | !d) & (!a | b | !c);

endmodule