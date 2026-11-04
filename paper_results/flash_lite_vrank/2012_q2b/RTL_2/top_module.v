module top_module (
	input [5:0] y,
	input w,
	output Y1,
	output Y3
);

	// State assignments:
	// y[5] = F
	// y[4] = E
	// y[3] = D
	// y[2] = C
	// y[1] = B
	// y[0] = A

	// Y1 (input for state flip-flop y[1], which represents state B)
	assign Y1 = (y[0] & w) | (y[5] & w); // A -> B (w=1) or F -> C -> B (w=1)

	// Y3 (input for state flip-flop y[3], which represents state D)
	assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[4] & ~w) | (y[5] & ~w); // B -> D (w=0) or C -> D (w=0) or E -> D (w=0) or F -> D (w=0)

endmodule