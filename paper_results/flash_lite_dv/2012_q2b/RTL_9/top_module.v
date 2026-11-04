module top_module (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Combinational Logic for Y1 (Input to state flip-flop y[1], representing state B)
    assign Y1 = (y[0] & w) | (y[5] & w);

    // Combinational Logic for Y3 (Input to state flip-flop y[3], representing state D)
    assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[4] & ~w) | (y[5] & ~w);

endmodule