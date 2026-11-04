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

// Next-state logic
assign S_next = (S && !d) || (S1 && !d);
assign S1_next = S && d;
assign Count_next = (Count && !done_counting) || (done_counting && Wait);
assign Wait_next = (Wait && !ack) || (done && ack);
assign B3_next = B3 ? 1 : (B2 ? 1 : (B1 ? 1 : (B0 ? 1 : 0)));

// Output logic
assign done = Wait && ack;
assign counting = Count;
assign shift_ena = B0 || B1 || B2 || B3;

endmodule