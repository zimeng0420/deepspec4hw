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

// Next-state logic
assign B3_next = state[9] & 1'b1; // B3 -> B0
assign S_next = state[0] & ~d; // S -> S
assign S1_next = state[1] & d; // S1 -> S11
assign Count_next = state[8] & done_counting; // Count -> Wait
assign Wait_next = state[9] & ack; // Wait -> S

// Output logic
assign done = state[9]; // done = Wait
assign counting = state[8]; // counting = Count
assign shift_ena = state[4] | state[5] | state[6] | state[7]; // shift_ena = B0, B1, B2, B3

endmodule