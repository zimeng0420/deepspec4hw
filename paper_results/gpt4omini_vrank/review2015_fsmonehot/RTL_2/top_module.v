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

    // State transition logic
    assign S_next = state[0] && d; // S --> S1 if d=1
    assign S1_next = state[1] && d ? 1 : state[1] && !d; // S1 --> S11 if d=1, else back to S
    assign Count_next = state[7] && state[6]; // B3 --> Count
    assign Wait_next = state[9] && done_counting && ack; // Wait --> S if ack=1

    assign B3_next = state[6] && 1'b1; // B3 always goes to next cycle

    // Output logic
    assign done = state[9]; // done is high in Wait state
    assign counting = state[7] || state[8]; // counting is high in Count state
    assign shift_ena = state[4] || state[5] || state[6] || state[7]; // shift_ena high in B0, B1, B2, B3

endmodule