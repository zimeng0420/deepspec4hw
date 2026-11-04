module top_module (
    input [6:1] y,
    input w,
    output Y2,
    output Y4
);

    // Deriving logic equations for Y2 and Y4 based on the state transitions
    assign Y2 = (~w & y[1]) | (~w & y[4]); // Transition to state B
    assign Y4 = (w & y[2]) | (~w & y[3]) | (w & y[5]); // Transition to state D

endmodule