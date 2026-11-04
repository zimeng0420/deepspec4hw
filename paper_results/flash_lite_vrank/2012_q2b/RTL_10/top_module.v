module top_module (
	input [5:0] y,
	input w,
	output Y1,
	output Y3
);

	// Y1 (input of y[1])
	assign Y1 = (y[0] & w) | (y[5] & w); // From A to B, From F to C (then C's y[1] will be set)

	// Y3 (input of y[3])
	assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[3] & ~w) | (y[4] & ~w) | (y[5] & ~w); // From B to D, From C to D, From D to A, From E to D, From F to D

endmodule