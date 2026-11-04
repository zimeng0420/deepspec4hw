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

// State index: (S, S1, S11, S110, B0, B1, B2, B3, Count, Wait)
parameter [9:0] S     = 10'b0000000001;
parameter [9:0] S1    = 10'b0000000010;
parameter [9:0] S11   = 10'b0000000100;
parameter [9:0] S110  = 10'b0000001000;
parameter [9:0] B0    = 10'b0000010000;
parameter [9:0] B1    = 10'b0000100000;
parameter [9:0] B2    = 10'b0001000000;
parameter [9:0] B3    = 10'b0010000000;
parameter [9:0] Count = 10'b0100000000;
parameter [9:0] Wait  = 10'b1000000000;

// Next-state logic
assign S_next     = (state[1] & ~d) | (state[3] & ~d) | (state[0] & ~d);
assign S1_next    = (state[0] & d) | (state[2] & ~d);
assign B3_next    = state[6];
assign Count_next = state[7];
assign Wait_next  = state[8] & done_counting;

// Output logic
assign done       = state[9];
assign counting   = state[8];
assign shift_ena  = state[4] | state[5] | state[6] | state[7];

endmodule