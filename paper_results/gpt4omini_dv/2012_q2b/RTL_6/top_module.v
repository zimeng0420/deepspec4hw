module top_module (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

assign Y1 = y[0] & w; // Activated when transitioning to state B from A
assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[5] & ~w); // Activated for state D from B, C, or F when w = 0

endmodule