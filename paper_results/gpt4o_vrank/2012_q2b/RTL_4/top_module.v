module top_module (
	input [5:0] y,
	input w,
	output Y1,
	output Y3
);

    // Finding the logic for Y1
    // Transition to B requires being in state A (y[0]) and input w being 1
    assign Y1 = y[0] & w;

    // Finding the logic for Y3
    // Transition to D requires being in state B with input w = 0 or C with w = 0 or F with w = 0
    // In all these cases, the transition to D occurs which represents state 3
    assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[5] & ~w);

endmodule