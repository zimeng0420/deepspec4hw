module top_module (
	input [5:0] y,
	input w,
	output Y1,
	output Y3
);

	// Y1 (input for y[1], which represents state B)
	assign Y1 = (y[0] & w) | (y[5] & w); // From A with w=1, From F with w=1

	// Y3 (input for y[3], which represents state D)
	assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[4] & ~w) | (y[5] & ~w); // From B with w=0, From C with w=0, From E with w=0, From F with w=0

endmodule