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

// Next State Logic
assign S_next = (state[0] & d) ? 1'b1 : 1'b0;         // from S to S1
assign S1_next = (state[1] & d) ? 1'b1 : 1'b0;       // from S1 to S11
assign B3_next = (state[8] & 1'b1) ? 1'b1 : 1'b0;    // B3 goes to Count with shift_ena=1
assign Count_next = (state[8] & done_counting) ? 1'b1 : 1'b0; // Count to Wait
assign Wait_next = (state[9] & ack) ? 1'b1 : 1'b0;   // Wait to S

// Output Logic
assign done = state[9];          // done is high when in Wait
assign counting = state[8];      // counting is high when in Count
assign shift_ena = (state[4] | state[5] | state[6] | state[7]); // B0, B1, B2, B3

endmodule