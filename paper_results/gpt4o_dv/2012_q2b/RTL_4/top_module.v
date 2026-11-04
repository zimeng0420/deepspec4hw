module top_module (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Implementing the logic for Y1 and Y3 based on the state transition diagram:
    // Y1 is for state B
    assign Y1 = y[0] & w;

    // Y3 is for state D
    assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[4] & ~w) | (y[5] & ~w);

endmodule