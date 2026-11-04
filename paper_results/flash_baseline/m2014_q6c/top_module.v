module top_module (
    input [6:1] y,
    input w,
    output Y2,
    output Y4
);

    assign Y2 = y[1] & ~w;  // Next state is B if current state is A and w is 0
    assign Y4 = y[2] & w | y[3] & w | y[5] & w | y[6] & w;  // Next state is D if current state is B and w is 1, or C and w is 1, or E and w is 1, or F and w is 1.

endmodule