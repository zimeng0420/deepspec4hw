module top_module (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

assign Y1 = y[0] & w;  // y[0] corresponds to state A and w = 1 activates transition to state B
assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[5] & ~w);  // y[1] from B, y[2] from C, or y[5] from F with w = 0 activates transition to state D

endmodule