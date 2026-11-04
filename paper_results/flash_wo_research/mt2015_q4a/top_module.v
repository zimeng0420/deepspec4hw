module top_module(
    input x,
    input y,
    output z
);

    assign z = (x ^ y) & x;
    // Alternatively, using the simplified expression:
    // assign z = x & ~y;

endmodule