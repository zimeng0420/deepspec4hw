module top_module (
	input [6:1] y,
	input w,
	output Y2,
	output Y4
);

assign Y2 = (y[6] & ~w) | (y[5] & ~w) | (y[4] & ~w) | (y[3] & ~w) | (y[2] & w); // Next-state logic for Y2
assign Y4 = (y[5] & ~w) | (y[4] & w) | (y[3] & ~w) | (y[2] & ~w);          // Next-state logic for Y4

endmodule