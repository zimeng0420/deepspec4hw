module top_module (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

assign Y1 = y[0] & w; // Y1 is activated when in state A (y[0] = 1) and w = 1
assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[5] & ~w); // Y3 is activated when in states B, C, or F with w = 0

endmodule