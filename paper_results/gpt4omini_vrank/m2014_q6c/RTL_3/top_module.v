module top_module (
    input [6:1] y,
    input w,
    output Y2,
    output Y4
);

assign Y2 = (y[2] & w) | (y[1] & ~w) | (y[4] & ~w); // Next state logic for Y2
assign Y4 = (y[1] & w) | (y[4] & w) | (y[3] & ~w); // Next state logic for Y4

endmodule