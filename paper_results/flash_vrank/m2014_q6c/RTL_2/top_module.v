module top_module (
    input [6:1] y,
    input w,
    output Y2,
    output Y4
);

    assign Y2 = y[1] & ~w;  // B is reached from A with input 0
    assign Y4 = (y[2] & w) | (y[3] & w) | (y[5] & w) | (y[6] & w); // D is reached from B with input 1, from C with input 1, from E with input 1, and from F with input 1.

endmodule