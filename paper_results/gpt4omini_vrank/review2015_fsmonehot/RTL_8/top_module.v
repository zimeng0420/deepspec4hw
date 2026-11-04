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
    assign S_next = state[0] & d; // from S on d=1
    assign S1_next = state[1] & d; // from S1 on d=1
    assign B3_next = state[3]; // always go to next cycle
    assign Count_next = state[8] & ~done_counting; // stay in count if not done
    assign Wait_next = state[9] & ack; // go to S when ack=1

    // Output logic
    assign done = state[9]; // done is active in Wait state
    assign counting = state[8]; // counting is active in Count state
    assign shift_ena = state[3] | state[4] | state[5] | state[6]; // active in B3, B2, B1, B0

endmodule