module top_module (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    assign Y1 = y[0] & w;  // Y1 is the input to flip-flop y[1] (B).  A goes to B when w is 1.

    assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[5] & ~w) | (y[4] & ~w);  //Y3 is the input to flip-flop y[3] (D). B goes to D when w is 0, C goes to D when w is 0, F goes to D when w is 0, E goes to D when w is 0
    
endmodule