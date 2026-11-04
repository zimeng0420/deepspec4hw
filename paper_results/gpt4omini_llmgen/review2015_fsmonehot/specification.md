```verilog
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

// State definitions based on one-hot encoding:
// S       = 10'b0000000001 (state[0])
// S1      = 10'b0000000010 (state[1])
// S11     = 10'b0000000100 (state[2])
// S110    = 10'b0000001000 (state[3])
// B0      = 10'b0000010000 (state[4])
// B1      = 10'b0000100000 (state[5])
// B2      = 10'b0001000000 (state[6])
// B3      = 10'b0010000000 (state[7])
// Count   = 10'b0100000000 (state[8])
// Wait    = 10'b1000000000 (state[9])

// Next-state logic
assign B3_next = state[7] && 1'b1;  // B3 always transitions to next state when shift_ena=1
assign S_next = (state[0] && d) || (state[1] && !d) || (state[3] && !d) || (state[4] && ack);
assign S1_next = (state[0] && d) || (state[2] && !d);
assign Count_next = state[8] && !done_counting;
assign Wait_next = state[8] && done_counting && ack;

// Output logic
assign done = state[9];               // done is asserted when in Wait state
assign counting = state[8];           // counting is asserted when in Count state
assign shift_ena = state[4] || state[5] || state[6] || state[7];  // shift_ena asserted in B0, B1, B2, B3

endmodule
```