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

    wire S = state[0];
    wire S1 = state[1];
    wire S11 = state[2];
    wire S110 = state[3];
    wire B0 = state[4];
    wire B1 = state[5];
    wire B2 = state[6];
    wire B3 = state[7];
    wire Count = state[8];
    wire Wait = state[9];

    assign S_next = ~S & ~d; // S can stay in S on d=0
    assign S1_next = S & d; // S1 can go to S when d=0
    assign Count_next = Count & ~done_counting; // Stays in Count unless done_counting is high
    assign Wait_next = Count & done_counting; // Move to Wait when done_counting is high
    assign B3_next = B3; // Always B3 to next state if shift_ena is high

    assign done = Wait; // done is high when in Wait state
    assign counting = Count; // counting is high when in Count state
    assign shift_ena = B0 | B1 | B2 | B3; // Shift enable is high in states B0 to B3

endmodule