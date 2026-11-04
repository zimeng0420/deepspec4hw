module submodule_A(
    input x,
    input y,
    output z
);
    assign z = (x ^ y) & x;
endmodule

module submodule_B(
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

    // Instantiate submodule A
    submodule_A A1(.x(x), .y(y), .z(A1_out));
    submodule_A A2(.x(x), .y(y), .z(A2_out));

    // Instantiate submodule B
    submodule_B B1(.x(x), .y(y), .z(B1_out));
    submodule_B B2(.x(x), .y(y), .z(B2_out));

    // OR gate for the first pair of A and B submodules
    assign OR_out = A1_out | B1_out;

    // AND gate for the second pair of A and B submodules
    assign AND_out = A2_out & B2_out;

    // XOR gate for the final output
    assign z = OR_out ^ AND_out;
endmodule