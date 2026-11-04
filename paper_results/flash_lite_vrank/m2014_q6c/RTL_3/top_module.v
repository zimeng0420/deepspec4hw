module top_module (
	input [6:1] y,
	input w,
	output Y2,
	output Y4
);

	// State assignments:
	// A: 000001 (y[1])
	// B: 000010 (y[2])
	// C: 000100 (y[3])
	// D: 001000 (y[4])
	// E: 010000 (y[5])
	// F: 100000 (y[6])

	// Next-state logic for Y2 (corresponds to state B)
	always_comb begin
		Y2 = (y[1] & ~w) | (y[6] & ~w); // A->B, F->C
	end

	// Next-state logic for Y4 (corresponds to state D)
	always_comb begin
		Y4 = (y[2] & w) | (y[3] & w) | (y[5] & w) | (y[6] & w); // B->D, C->D, E->D, F->D
	end

endmodule