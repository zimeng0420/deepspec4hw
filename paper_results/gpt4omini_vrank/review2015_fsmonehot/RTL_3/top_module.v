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
    assign S_next = state[0] & d;                   // S --d=1--> S1
    assign S1_next = state[1] & d;                  // S1 --d=1--> S11
    assign Count_next = state[7] & !done_counting;  // Count --!(done_counting)--> Count
    assign Wait_next = state[9] & ack;               // Wait --ack=1--> S

    assign B3_next = state[6];                       // B3 (always go to next cycle) --> Count

    assign done = (state[9] && ack);                  // Wait (done=1) --ack=1--> S
    assign counting = state[7];                       // Count (counting=1)
    assign shift_ena = state[5] || state[6] || state[7] || state[8]; // B0 to B3 states

endmodule