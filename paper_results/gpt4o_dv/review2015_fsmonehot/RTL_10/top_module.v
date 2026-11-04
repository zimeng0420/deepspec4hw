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
    
    // Next-state logic based on the transition diagram and one-hot encoding
    assign S_next = (state[1] & ~d) | (state[3] & ~d) | (state[0] & ~d); // S1->S, S110->S, S->S
    assign S1_next = (state[0] & d) | (state[2] & ~d); // S->S1 and S11->S1
    assign B3_next = state[6]; // B2->B3
    assign Count_next = state[7]; // B3->Count
    assign Wait_next = (state[8] & done_counting); // Count->Wait when done_counting = 1
    
    // Output logic based on current states
    assign done = state[9]; // Wait state
    assign counting = state[8]; // Count state
    assign shift_ena = state[4] | state[5] | state[6] | state[7]; // B0, B1, B2, B3 states

endmodule