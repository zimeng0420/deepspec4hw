module top_module(
    input d,
    input done_counting,
    input ack,
    input [9:0] state,    // 10-bit one-hot current state
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

// Next-state logic equations:
assign B3_next = state[7] & shift_ena; // state B3 -> next state
assign S_next = (state[0] & ~d) | (state[1] & ~d) | (state[3] & ~d) | (state[4] & ack); // state S transitions
assign S1_next = state[0] & d; // state S to S1 transition
assign Count_next = state[8] | (state[8] & ~done_counting); // Count state persistence
assign Wait_next = state[8] & done_counting; // Count to Wait transition

// Output logic equations:
assign done = state[9]; // Output done when in Wait state
assign counting = state[8]; // Output counting when in Count state
assign shift_ena = state[4] | state[5] | state[6] | state[7]; // Shift enable from B0 to B3 states

endmodule