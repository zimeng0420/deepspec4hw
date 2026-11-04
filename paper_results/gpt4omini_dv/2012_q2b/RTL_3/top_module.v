module top_module (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    assign Y1 = y[0] & w; // Y1 is active when in state A and w is 1
    assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[5] & ~w); // Y3 is active when FSM is in state B, C, or F and w is 0

endmodule