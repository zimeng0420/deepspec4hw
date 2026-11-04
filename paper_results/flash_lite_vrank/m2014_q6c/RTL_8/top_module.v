module top_module (
	input [6:1] y,
	input w,
	output Y2,
	output Y4
);

	// State assignments (One-hot encoding):
	// y[6:1] = 000001: A
	// y[6:1] = 000010: B
	// y[6:1] = 000100: C
	// y[6:1] = 001000: D
	// y[6:1] = 010000: E
	// y[6:1] = 100000: F

	// Next-state logic for Y2 (corresponding to state C)
	// State C (y[3]) will be active in the next cycle if:
	//   - Current state is B (y[2]) and w = 0
	//   - Current state is F (y[6]) and w = 0
	assign Y2 = (y[2] & ~w) | (y[6] & ~w);

	// Next-state logic for Y4 (corresponding to state E)
	// State E (y[5]) will be active in the next cycle if:
	//   - Current state is C (y[3]) and w = 0
	assign Y4 = (y[3] & ~w);

endmodule