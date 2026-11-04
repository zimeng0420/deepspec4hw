module top_module (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Combinational Logic for Y1
    assign Y1 = (y[0] & w) | (y[5] & w);

    // Combinational Logic for Y3
    assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[4] & ~w) | (y[5] & ~w);

endmodule