module top_module (
	input [6:1] y,
	input w,
	output Y2,
	output Y4
);

  // State Definitions (One-Hot Encoding)
  // y[6:1] = 000001: A
  // y[6:1] = 000010: B
  // y[6:1] = 000100: C
  // y[6:1] = 001000: D
  // y[6:1] = 010000: E
  // y[6:1] = 100000: F

  // Next State Logic for Y2 (State C)
  // Y2 will be high if the next state is C.
  // Next state is C from B with w=0 and F with w=0
  assign Y2 = (y[2] & ~w) | (y[6] & ~w); // B with w=0 or F with w=0

  // Next State Logic for Y4 (State E)
  // Y4 will be high if the next state is E.
  // Next state is E from C with w=0
  assign Y4 = (y[3] & ~w); // C with w=0

endmodule