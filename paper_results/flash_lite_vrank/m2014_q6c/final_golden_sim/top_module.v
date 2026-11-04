module top_module (
	input [6:1] y,
	input w,
	output Y2,
	output Y4
);

  // State assignments:
  // y[6:1] = 000001 -> A
  // y[6:1] = 000010 -> B
  // y[6:1] = 000100 -> C
  // y[6:1] = 001000 -> D
  // y[6:1] = 010000 -> E
  // y[6:1] = 100000 -> F

  // Y2 (Next state of C, i.e., y[3]) Logic by inspection:
  // Next C (Y[3] = 1) : B(w=0) or F(w=0)
  assign Y2 = (y[2] & ~w) | (y[6] & ~w);

  // Y4 (Next state of E, i.e., y[5]) Logic by inspection:
  // Next E (Y[5] = 1) : C(w=0)
  assign Y4 = (y[3] & ~w);


endmodule