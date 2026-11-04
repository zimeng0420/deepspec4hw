module top_module (
	input [5:0] y,
	input w,
	output Y1,
	output Y3
);
    // State encodings (one-hot)
    // A: 000001
    // B: 000010
    // C: 000100
    // D: 001000
    // E: 010000
    // F: 100000

    // Y1 (input to y[1], state B)
    assign Y1 = (y[0] & w) | (y[5] & w); // From A with w=1, from F with w=1

    // Y3 (input to y[3], state D)
    assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[3] & ~w) | (y[4] & ~w) | (y[5] & ~w); // From B with w=0, from C with w=0, from D with w=0, from E with w=0, from F with w=0

endmodule