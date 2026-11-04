module top_module (
    input [6:1] y,
    input w,
    output Y2,
    output Y4
);

    assign Y2 = y[1] & ~w;  // Next state B from A when w is 0
    assign Y4 = (y[2] & w) | (y[3] & w) | (y[5] & w) | (y[6] & w);  // Next state D from B, C, E, F when w is 1
    
endmodule