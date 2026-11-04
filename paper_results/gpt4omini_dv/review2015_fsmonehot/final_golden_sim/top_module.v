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
assign B3_next = state[7] & 1; // B3 to Next State
assign S_next = (state[0] & !d) | (state[1] & !d) | (state[3] & !d) | (state[4] & ack); // S to Next State
assign S1_next = state[0] & d; // S to S1
assign Count_next = state[8] | (state[8] & !done_counting); // Count to Next State
assign Wait_next = state[8] & done_counting; // Count to Wait

// Output logic equations:
assign done = state[9]; // Wait state outputs done
assign counting = state[8]; // Count outputs counting
assign shift_ena = state[4] | state[5] | state[6] | state[7]; // B0, B1, B2, B3 enable shifting

endmodule