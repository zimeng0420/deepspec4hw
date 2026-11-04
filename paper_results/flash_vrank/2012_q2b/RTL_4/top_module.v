module top_module (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    assign Y1 = y[0] & w;  // Y1 is the input to the flip-flop for state B (y[1]). State A transitions to B when w=1.

    assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[5] & ~w) | (y[4] & ~w);  // Y3 is the input to the flip-flop for state D (y[3]). B->D when w=0, C->D when w=0, F->D when w=0, E->D when w=0
endmodule