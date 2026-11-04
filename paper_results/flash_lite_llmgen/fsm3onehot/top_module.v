module top_module (
	input in,
	input [3:0] state,
	output reg [3:0] next_state,
	output reg out
);

  always @(*) begin
    // State Transition Logic
    next_state[0] = (state[0] & ~in) | (state[2] & ~in); // Next state A
    next_state[1] = (state[0] & in) | (state[1] & in) | (state[3] & in); // Next state B
    next_state[2] = (state[1] & ~in) | (state[3] & ~in); // Next state C
    next_state[3] = (state[2] & in); // Next state D

    // Output Logic
    out = state[3]; // Output is 1 when in state D
  end

endmodule