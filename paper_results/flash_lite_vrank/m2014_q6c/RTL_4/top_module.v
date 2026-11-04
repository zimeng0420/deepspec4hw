module top_module (
	input [6:1] y,
	input w,
	output Y2,
	output Y4
);

	// State A: y[1]
	// State B: y[2]
	// State C: y[3]
	// State D: y[4]
	// State E: y[5]
	// State F: y[6]

	// Next state logic for Y2 (State B)
	// State A -> B if w = 0
	assign Y2 = (y[1] & ~w);


	// Next state logic for Y4 (State D)
	// State B -> D if w = 1
	// State C -> D if w = 1
	// State E -> D if w = 1
	// State F -> D if w = 1
	assign Y4 = (y[2] & w) | (y[3] & w) | (y[5] & w) | (y[6] & w);


endmodule