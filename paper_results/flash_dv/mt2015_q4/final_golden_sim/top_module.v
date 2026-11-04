module top_module(
    input x,
    input y,
    output z
);

    wire A_out1, A_out2, B_out1, B_out2, OR_out, AND_out;

    // Instantiate Module A
    module_A A1 (
        .x(x),
        .y(y),
        .z(A_out1)
    );

    module_A A2 (
        .x(x),
        .y(y),
        .z(A_out2)
    );

    // Instantiate Module B
    module_B B1 (
        .x(x),
        .y(y),
        .z(B_out1)
    );

    module_B B2 (
        .x(x),
        .y(y),
        .z(B_out2)
    );

    // OR gate
    assign OR_out = A_out1 | B_out1;

    // AND gate
    assign AND_out = A_out2 & B_out2;

    // XOR gate
    assign z = OR_out ^ AND_out;

endmodule

module module_A(
    input x,
    input y,
    output z
);

    assign z = (x ^ y) & x;

endmodule

module module_B(
    input x,
    input y,
    output z
);

    assign z = (~x & ~y) | (x & y);

endmodule