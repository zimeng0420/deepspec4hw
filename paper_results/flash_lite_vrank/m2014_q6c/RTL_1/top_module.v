module top_module (
	input [6:1] y,
	input w,
	output Y2,
	output Y4
);

  // State assignments (one-hot encoding)
  // A: 000001 (y[1])
  // B: 000010 (y[2])
  // C: 000100 (y[3])
  // D: 001000 (y[4])
  // E: 010000 (y[5])
  // F: 100000 (y[6])


  // Logic for Y2 (Next state bit 2, corresponding to state B)

  // Y2 becomes 1 if:
  // - Current state is A (y[1] == 1) and w == 0
  Y2 = (y[1] & ~w);
  
  // Logic for Y4 (Next state bit 4, corresponding to state D)

  // Y4 becomes 1 if:
  // - Current state is B (y[2] == 1) and w == 1
  // - Current state is C (y[3] == 1) and w == 1
  // - Current state is D (y[4] == 1) and w == 1
  // - Current state is E (y[5] == 1) and w == 1
  // - Current state is F (y[6] == 1) and w == 1
  Y4 = (y[2] & w) | (y[3] & w) | (y[5] & w) | (y[6] & w);
  
endmodule