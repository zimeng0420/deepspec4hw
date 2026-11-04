module top_module (
	input [6:1] y,
	input w,
	output Y2,
	output Y4
);

  // State assignments:
  // A: y[6:1] = 000001
  // B: y[6:1] = 000010
  // C: y[6:1] = 000100
  // D: y[6:1] = 001000
  // E: y[6:1] = 010000
  // F: y[6:1] = 100000

  // Next-state logic for Y2 (state C)
  // From B: if w==0
  // From F: if w==0

  assign Y2 = (y[2] & ~w) | (y[6] & ~w);


  // Next-state logic for Y4 (state E)
  // From C: if w==0

  assign Y4 = (y[3] & ~w);


endmodule