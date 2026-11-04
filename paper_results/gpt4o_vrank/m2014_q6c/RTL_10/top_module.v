module top_module (
    input [6:1] y,
    input w,
    output Y2,
    output Y4
);

    // Derive the logic for Y2 and Y4 based on state transitions.
    // Y2 corresponds to state B, which is reached from:
    // - A with w=0: y[1] & ~w

    assign Y2 = (y[1] & ~w);

    // Y4 corresponds to state D, which is reached from:
    // - B with w=1: y[2] & w
    // - C with w=1: y[3] & w
    // - F with w=1: y[6] & w

    assign Y4 = (y[2] & w) | (y[3] & w) | (y[6] & w);

endmodule