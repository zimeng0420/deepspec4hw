module top_module (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // State assignment: 
    // A = 000001, B = 000010, C = 000100, D = 001000, E = 010000, F = 100000

    // Derive Y1 (next state B):
    assign Y1 = (y[0] & w) | (y[3] & w);

    // Derive Y3 (next state D):
    assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[5] & ~w);

endmodule