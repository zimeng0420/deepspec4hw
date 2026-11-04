module top_module (
	input [5:0] y,
	input w,
	output Y1,
	output Y3
);

  // Calculate Y1
  assign Y1 = (y[0] & w) | (y[5] & w); // B = (A & w) | (F & w)

  // Calculate Y3
  assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[3] & ~w) | (y[4] & ~w) | (y[5] & ~w); // D = (B & ~w) | (C & ~w) | (D & ~w) | (E & ~w) | (F & ~w)

endmodule