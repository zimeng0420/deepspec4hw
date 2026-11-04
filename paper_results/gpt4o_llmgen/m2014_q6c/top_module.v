module top_module (
    input [6:1] y,
    input w,
    output Y2,
    output Y4
);

    // Logic equation for Y2 (next state B):
    // Y2 is high if the current state is A (y[1] = 1) and w = 0,
    // or if the current state is F (y[6] = 1) and w = 0,
    // or if the current state is C (y[3] = 1) and w = 1.
    assign Y2 = (y[1] & ~w) | (y[6] & ~w) | (y[3] & w);

    // Logic equation for Y4 (next state D):
    // Y4 is high if the current state is B (y[2] = 1) and w = 1,
    // or if the current state is C (y[3] = 1) and w = 1,
    // or if the current state is F (y[6] = 1) and w = 1,
    // or if the current state is D (y[4] = 1) and w = 1.
    assign Y4 = (y[2] & w) | (y[3] & w) | (y[6] & w) | (y[4] & w);

endmodule