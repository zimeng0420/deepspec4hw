module top_module (
	input [5:0] y,
	input w,
	output Y1,
	output Y3
);

  // Y1: Input to flip-flop y[1] (state B)
  assign Y1 = (y[0] & w) | (y[5] & w);  // From A with w=1, From F with w=1

  // Y3: Input to flip-flop y[3] (state D)
  assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[3] & ~w) | (y[4] & ~w) | (y[5] & ~w); // From B with w=0, C with w=0, D with w=0, E with w=0, F with w=0


endmodule