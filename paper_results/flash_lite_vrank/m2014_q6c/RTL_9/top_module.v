module top_module (
	input [6:1] y,
	input w,
	output Y2,
	output Y4
);

  // Next state logic for Y2 (state C)
  // C = (B & ~w) | (F & ~w)
  assign Y2 = (y[2] & ~w) | (y[6] & ~w); // y[2] represents state B and y[6] represents state F

  // Next state logic for Y4 (state E)
  // E = (C & ~w) | (E & ~w)
  assign Y4 = (y[3] & ~w) | (y[5] & ~w); // y[3] represents state C and y[5] represents state E

endmodule