module top_module(
    input x,
    input y,
    output z
);

    // Module A: z = (x^y) & x
    module module_a(
        input x,
        input y,
        output z
    );
        assign z = (x ^ y) & x;
    endmodule

    // Module B: z = (!x & !y) | (x & y)  (XNOR)
    module module_b(
        input x,
        input y,
        output z
    );
        assign z = (~x & ~y) | (x & y);
    endmodule

    wire a1_out, a2_out, b1_out, b2_out;
    wire or_out, and_out;

    // Instantiate Module A
    module_a a1 (
        .x(x),
        .y(y),
        .z(a1_out)
    );

    module_a a2 (
        .x(x),
        .y(y),
        .z(a2_out)
    );

    // Instantiate Module B
    module_b b1 (
        .x(x),
        .y(y),
        .z(b1_out)
    );

    module_b b2 (
        .x(x),
        .y(y),
        .z(b2_out)
    );

    // OR gate
    assign or_out = a1_out | b1_out;

    // AND gate
    assign and_out = a2_out & b2_out;

    // XOR gate
    assign z = or_out ^ and_out;

endmodule