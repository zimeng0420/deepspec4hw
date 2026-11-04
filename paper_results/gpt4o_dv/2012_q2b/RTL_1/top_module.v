module top_module (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Next-State Logic for Y1 (State B): Y1 = y[0] & w
    assign Y1 = y[0] & w;
    
    // Next-State Logic for Y3 (State D): 
    // Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[4] & ~w) | (y[5] & ~w)
    assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[4] & ~w) | (y[5] & ~w);

endmodule