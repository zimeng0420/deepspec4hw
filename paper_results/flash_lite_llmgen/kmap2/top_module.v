module top_module (
	input a,
	input b,
	input c,
	input d,
	output out
);

  // Optimized implementation based on Karnaugh map analysis
  assign out = (~a & ~c) | (~a & ~b) | (~b & ~d) | (a & c & d) | (b & ~c & d);

endmodule