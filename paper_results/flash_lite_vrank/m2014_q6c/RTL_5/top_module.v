module top_module (
	input [6:1] y,
	input w,
	output Y2,
	output Y4
);

  // State assignments (one-hot encoding)
  // A: 000001 (y[1])
  // B: 000010 (y[2])
  // C: 000100 (y[3])
  // D: 001000 (y[4])
  // E: 010000 (y[5])
  // F: 100000 (y[6])

  // Next-state logic for y[2] (B)
  assign Y2 = (y[1] & ~w) | (y[6] & ~w); // From A(0) or F(0)

  // Next-state logic for y[4] (D)
  assign Y4 = (y[2] & w) | (y[3] & w) | (y[5] & w) | (y[6] & w); // From B(1) or C(1) or E(1) or F(1)

endmodule