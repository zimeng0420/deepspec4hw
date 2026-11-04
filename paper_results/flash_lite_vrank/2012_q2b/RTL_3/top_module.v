module top_module (
	input [5:0] y,
	input w,
	output Y1,
	output Y3
);

  // Calculate Y1 (input for y[1] - state B)
  assign Y1 = (y[0] & w) | (y[5] & w); // A -> B, F -> C -> B

  // Calculate Y3 (input for y[3] - state D)
  assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[3] & ~w) | (y[4] & ~w) | (y[5] & ~w); // B -> D, C -> D, D -> A ->D, E->D, F->D

endmodule