module top_module(
    input x,
    input y,
    output z
);

    wire A1_out, A2_out, B1_out, B2_out;
    wire OR_out, AND_out;

    // Submodule A definition
    assign A1_out = (x ^ y) & x;
    assign A2_out = (x ^ y) & x;

    // Submodule B definition
    assign B1_out = (~x & ~y) | (x & y);
    assign B2_out = (~x & ~y) | (x & y);

    // Logic gates
    assign OR_out = A1_out | B1_out;
    assign AND_out = A2_out & B2_out;
    assign z = OR_out ^ AND_out;

endmodule