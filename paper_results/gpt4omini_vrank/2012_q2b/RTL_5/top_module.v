module top_module (
	input [5:0] y,
	input w,
	output Y1,
	output Y3
);
	assign Y1 = (y[0] & w) | (y[1] & ~w);   // From state A (y[0]) to B (y[1]) and B to D
	assign Y3 = (y[1] & ~w) | (y[2] & w) | (y[3] & ~w); // From state B (y[1]) to D (y[3]), C (y[2]) to E, and D to A
endmodule