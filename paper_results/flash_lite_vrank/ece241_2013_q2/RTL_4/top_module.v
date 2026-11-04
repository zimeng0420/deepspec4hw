module top_module (
	input a,
	input b,
	input c,
	input d,
	output out_sop,
	output out_pos
);

	// SOP implementation
	assign out_sop = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d); // minterms 2, 7, 15

	// POS implementation
	assign out_pos = (a | ~b | ~c) & (a | ~b | ~d) & (~a | b | ~c) & (~a | b | ~d); // maxterms 0, 1, 4, 5, 6, 9, 10, 13, 14

endmodule