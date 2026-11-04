module top_module (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Logic for Y1 (Next-State Logic for State B)
    assign Y1 = y[0] & w;
    
    // Logic for Y3 (Next-State Logic for State D)
    assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[4] & ~w) | (y[5] & ~w);

endmodule