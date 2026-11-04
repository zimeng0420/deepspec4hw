module top_module (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    assign Y1 = (y[0] & w) | (y[5] & w);  // Next state of B (y[1]) is reached from A with w=1 or F with w=1.
    assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[4] & ~w) | (y[5] & ~w);  // Next state of D (y[3]) is reached from B with w=0, C with w=0, E with w=0 or F with w=0.

endmodule