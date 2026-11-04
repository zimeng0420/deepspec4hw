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

module top_module(
    input x,
    input y,
    output z
);
    wire A1_out, A2_out, B1_out, B2_out;
    wire OR_out, AND_out;

    // Instantiate first instance of A and B
    module_A A1(
        .x(x),
        .y(y),
        .z(A1_out)
    );

    module_B B1(
        .x(x),
        .y(y),
        .z(B1_out)
    );

    // Instantiate second instance of A and B
    module_A A2(
        .x(x),
        .y(y),
        .z(A2_out)
    );

    module_B B2(
        .x(x),
        .y(y),
        .z(B2_out)
    );

    // OR gate for first pair outputs
    assign OR_out = A1_out | B1_out;

    // AND gate for second pair outputs
    assign AND_out = A2_out & B2_out;

    // XOR gate for final output
    assign z = OR_out ^ AND_out;
endmodule