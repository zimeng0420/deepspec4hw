module top_module (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    assign Y1 = (y[0] & w) | (y[3] & ~w); // From A to B or from D to D
    assign Y3 = (~w & (y[1] | y[2])); // From B to D or from C to D

endmodule