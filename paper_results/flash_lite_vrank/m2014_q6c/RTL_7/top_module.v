module top_module (
	input [6:1] y,
	input w,
	output Y2,
	output Y4
);

	// State A: y[1] = 1
	// State B: y[2] = 1
	// State C: y[3] = 1
	// State D: y[4] = 1
	// State E: y[5] = 1
	// State F: y[6] = 1

	// Next state logic for Y2 (corresponding to y[2], state B)
	// B is next state from A (w=0), D (w=1), and F (w=1)
	assign Y2 = (y[1] & !w) | (y[4] & w) | (y[6] & w);

	// Next state logic for Y4 (corresponding to y[4], state D)
	// D is next state from B (w=1), C (w=1), E (w=1), F (w=1)
	assign Y4 = (y[2] & w) | (y[3] & w) | (y[5] & w) | (y[6] & w);

endmodule