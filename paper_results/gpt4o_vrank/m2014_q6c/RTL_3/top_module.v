module top_module (
    input [6:1] y,
    input w,
    output Y2,
    output Y4
);
    // Assign the logic for Y2 and Y4 using one-hot encoding
    assign Y2 = (y[1] & ~w) | (y[2] & ~w);
    assign Y4 = (y[2] & w) | (y[3] & ~w) | (y[5] & w);
endmodule