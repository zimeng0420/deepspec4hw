module top_module (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    assign Y1 = y[0] & w;  // Y1 is the input to flip-flop y[1] (state B).  Transition to B occurs from A on input w=1.
    assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[5] & ~w) | (y[4] & ~w);  // Y3 is the input to flip-flop y[3] (state D). Transition to D occurs from B on w=0, from C on w=0, from F on w=0, from E on w=0
    
endmodule