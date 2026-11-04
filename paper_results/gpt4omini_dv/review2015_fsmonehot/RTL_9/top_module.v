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
assign B3_next = state[3] & (state[4] | state[5] | state[6] | state[7]); // B3 to next state if shift_ena
assign S_next = (state[0] & !d) | (state[1] & !d) | (state[3] & !d) | (state[8] & ack); // Transitions to S
assign S1_next = state[0] & d; // S to S1 if d=1
assign Count_next = state[8] | (state[8] & !done_counting); // Count stays active
assign Wait_next = state[8] & done_counting; // Transition from Count to Wait

// Output logic equations:
assign done = state[9]; // Output done when in Wait state
assign counting = state[8]; // Output counting when in Count state
assign shift_ena = state[4] | state[5] | state[6] | state[7]; // Shift enabled in B0, B1, B2, B3 states

endmodule