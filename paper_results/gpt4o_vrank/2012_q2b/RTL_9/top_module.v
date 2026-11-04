module top_module (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 is associated with state B, which is accessed from state A with input w.
    assign Y1 = (y[0] & w);

    // Y3 is associated with state D, reached from either state B with (!w), state C with (!w), or state F with (!w)
    assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[5] & ~w);

endmodule