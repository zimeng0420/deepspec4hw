module top_module (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    assign Y1 = y[0] & w;  // Y1 is input to flip-flop for state B (y[1]). Transition from A to B on w=1.
    assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[5] & ~w) | (y[4] & ~w);  // Y3 is input to flip-flop for state D (y[3]).  Transitions from B to D, C to D, F to D and E to D on w=0.

endmodule