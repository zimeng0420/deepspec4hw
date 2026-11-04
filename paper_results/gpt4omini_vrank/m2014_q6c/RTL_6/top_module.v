module top_module (
    input [6:1] y,
    input w,
    output Y2,
    output Y4
);

    // Next-state logic for Y2
    assign Y2 = (y[2] & w) |   // State B (y[2]), w=1 -> remains in B
                (y[3] & ~w) |  // State C (y[3]), w=0 -> goes to E (not affecting Y2)
                (y[4] & ~w) |  // State D (y[4]), w=0 -> goes to A (not affecting Y2)
                (y[5] & w) ;   // State E (y[5]), w=1 -> goes to D (not affecting Y2)

    // Next-state logic for Y4
    assign Y4 = (y[2] & w) |   // State B (y[2]), w=1 -> goes to D
                (y[3] & w) |   // State C (y[3]), w=1 -> goes to D
                (y[4] & ~w) |  // State D (y[4]), w=0 -> goes to A (not affecting Y4)
                (y[5] & ~w) |  // State E (y[5]), w=0 -> remains in E
                (y[6] & w) ;   // State F (y[6]), w=1 -> goes to D

endmodule