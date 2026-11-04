module top_module (
    input [6:1] y,
    input w,
    output Y2,
    output Y4
);

    // Derive Y2 and Y4 based on the state transitions and one-hot encoding 
    assign Y2 = (y[1] & ~w) | (y[4] & ~w); // Transitions to B from A with input 0, and to D from D with input 0 
    assign Y4 = (y[2] & w) | (y[3] & w) | (y[5] & w) | (y[6] & w); // Transitions to D from B, C, E, F with input 1

endmodule