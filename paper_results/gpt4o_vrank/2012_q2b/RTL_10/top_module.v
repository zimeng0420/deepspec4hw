module top_module (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);
    // Output Y1 is the input to state B (000010) in the one-hot encoding
    assign Y1 = (y[0] & w); // From state A to state B on input w = 1

    // Output Y3 is the input to state D (001000) in the one-hot encoding
    assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[5] & ~w); // From state B, C, and F to state D on input w = 0

endmodule