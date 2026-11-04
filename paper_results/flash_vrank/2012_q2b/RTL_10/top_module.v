module top_module (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    assign Y1 = (y[0] & w) | (y[5] & w);  // Y1 is the input to flip-flop y[1] (B)
    assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[4] & ~w) | (y[5] & ~w);  // Y3 is the input to flip-flop y[3] (D)

endmodule