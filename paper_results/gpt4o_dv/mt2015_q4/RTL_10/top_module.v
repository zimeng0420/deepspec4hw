module A (
    input x,
    input y,
    output z
);
    assign z = (x ^ y) & x;
endmodule

module B (
    input x,
    input y,
    output z
);
    assign z = (~x & ~y) | (x & y);
endmodule

module top_module(
    input x,
    input y,
    output z
);
    wire A1_out, A2_out, B1_out, B2_out;
    wire OR_out, AND_out;

    // Instantiate first A and B submodules
    A u1 (
        .x(x),
        .y(y),
        .z(A1_out)
    );

    B u2 (
        .x(x),
        .y(y),
        .z(B1_out)
    );

    // Instantiate second A and B submodules
    A u3 (
        .x(x),
        .y(y),
        .z(A2_out)
    );

    B u4 (
        .x(x),
        .y(y),
        .z(B2_out)
    );

    // OR gate for the first pair of A and B submodule outputs
    assign OR_out = A1_out | B1_out;

    // AND gate for the second pair of A and B submodule outputs
    assign AND_out = A2_out & B2_out;

    // XOR gate for the outputs of the OR and AND gates
    assign z = OR_out ^ AND_out;
endmodule