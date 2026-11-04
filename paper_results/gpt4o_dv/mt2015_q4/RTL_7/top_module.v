module top_module(
    input x,
    input y,
    output z);

    // Submodule A implements z = (x ^ y) & x
    wire A1_out, A2_out;
    assign A1_out = (x ^ y) & x;
    assign A2_out = (x ^ y) & x;

    // Submodule B implements z = (~x & ~y) | (x & y)
    wire B1_out, B2_out;
    assign B1_out = (~x & ~y) | (x & y);
    assign B2_out = (~x & ~y) | (x & y);

    // OR and AND gates for combining submodule outputs
    wire OR_out, AND_out;
    assign OR_out = A1_out | B1_out;
    assign AND_out = A2_out & B2_out;

    // XOR gate for final output
    assign z = OR_out ^ AND_out;

endmodule