module top_module (
	input [5:0] y,
	input w,
	output Y1,
	output Y3
);

	assign Y1 = (y[0] & w) | (y[5] & w); // y[1] is active in state B, and in state C. State B is reached from A with w=1, and state C is reached from F with w=1.
	assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[3] & ~w) | (y[4] & ~w) | (y[5] & ~w); // y[3] is active in state D, and state D is reached from B with w=0, from C with w=0, from E with w=0, from F with w=0.

endmodule