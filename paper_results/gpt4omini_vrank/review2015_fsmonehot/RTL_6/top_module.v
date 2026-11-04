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

// Next state logic
assign B3_next = (state[8] & 1'b1) ? 1'b1 : 1'b0; // B3 to next state (always go to Count)
assign S_next = (state[0] & ~d) ? 1'b1 : 1'b0; // S to S (d=0)
assign S1_next = (state[1] & d) ? 1'b1 : 1'b0; // S1 to S11 (d=1)
assign Count_next = (state[9] & done_counting) ? 1'b1 : 1'b0; // Count to Wait (done_counting=1)
assign Wait_next = (state[9] & done & ack) ? 1'b1 : 1'b0; // Wait to S (done=1, ack=1)

// Output logic
assign done = (state[9] & done_counting); // done when in Count state and done_counting is high
assign counting = (state[9]); // counting when in Count state
assign shift_ena = (state[4] | state[5] | state[6] | state[7]); // shift_ena when in B0, B1, B2, B3

endmodule