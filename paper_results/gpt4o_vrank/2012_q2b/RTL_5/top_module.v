module top_module (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 is the input of state flip-flop y[1] (corresponding to state B)
    assign Y1 = (y[0] & w) | (y[3] & ~w);

    // Y3 is the input of state flip-flop y[3] (corresponding to state D)
    assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[5] & ~w);

endmodule