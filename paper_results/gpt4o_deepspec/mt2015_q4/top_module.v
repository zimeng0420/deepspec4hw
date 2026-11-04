module top_module(
    input x,
    input y,
    output z
);

    // Submodule A
    module A(
        input x,
        input y,
        output z
    );
        assign z = (x ^ y) & x;
    endmodule

    // Submodule B
    module B(
        input x,
        input y,
        output z
    );
        assign z = (~x & ~y) | (x & y);
    endmodule

    // Signals for submodule outputs
    wire A1_out, A2_out, B1_out, B2_out;
    wire OR_out, AND_out;

    // Instantiating Submodule A and B
    A A1 (.x(x), .y(y), .z(A1_out));
    B B1 (.x(x), .y(y), .z(B1_out));

    A A2 (.x(x), .y(y), .z(A2_out));
    B B2 (.x(x), .y(y), .z(B2_out));

    // Combine outputs with gates
    assign OR_out = A1_out | B1_out;
    assign AND_out = A2_out & B2_out;
    assign z = OR_out ^ AND_out;

endmodule