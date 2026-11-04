module top_module(
    input x,
    input y,
    output z
);

    wire A_out1, A_out2, B_out1, B_out2, OR_out, AND_out;

    // Instantiate Module A
    A A1 (
        .x(x),
        .y(y),
        .z(A_out1)
    );

    A A2 (
        .x(x),
        .y(y),
        .z(A_out2)
    );

    // Instantiate Module B
    B B1 (
        .x(x),
        .y(y),
        .z(B_out1)
    );

    B B2 (
        .x(x),
        .y(y),
        .z(B_out2)
    );

    // Instantiate OR gate
    assign OR_out = A_out1 | B_out1;

    // Instantiate AND gate
    assign AND_out = A_out2 & B_out2;

    // Instantiate XOR gate
    assign z = OR_out ^ AND_out;

endmodule

module A(
    input x,
    input y,
    output z
);

    assign z = (x ^ y) & x;

endmodule

module B(
    input x,
    input y,
    output z
);

    assign z = (~x & ~y) | (x & y);

endmodule