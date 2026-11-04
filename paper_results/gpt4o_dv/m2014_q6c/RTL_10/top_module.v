module top_module (
    input [6:1] y,
    input w,
    output Y2,
    output Y4
);

    // Logic for Y2 (Next state B): Transition from state A to B when w is 0
    assign Y2 = y[1] & ~w;

    // Logic for Y4 (Next state D): Transition to state D from B, C, E, F when w is 1
    assign Y4 = (y[2] & w) | (y[3] & w) | (y[5] & w) | (y[6] & w);

endmodule