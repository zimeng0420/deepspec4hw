module SubmoduleA(
    input x,
    input y,
    output z
);
    assign z = (x ^ y) & x;
endmodule

module SubmoduleB(
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

    // Instantiate Submodule A instances
    SubmoduleA A1 (
        .x(x),
        .y(y),
        .z(A1_out)
    );

    SubmoduleA A2 (
        .x(x),
        .y(y),
        .z(A2_out)
    );

    // Instantiate Submodule B instances
    SubmoduleB B1 (
        .x(x),
        .y(y),
        .z(B1_out)
    );

    SubmoduleB B2 (
        .x(x),
        .y(y),
        .z(B2_out)
    );

    // OR gate with outputs of first A and B instances
    assign OR_out = A1_out | B1_out;

    // AND gate with outputs of second A and B instances
    assign AND_out = A2_out & B2_out;

    // XOR gate with outputs of OR and AND gates
    assign z = OR_out ^ AND_out;
endmodule