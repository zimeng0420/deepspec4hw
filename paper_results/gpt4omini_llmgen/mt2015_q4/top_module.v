module top_module(
    input x,
    input y,
    output z
);
    wire a1_out, a2_out, b1_out, b2_out;
    wire or_out, and_out;

    // Instances of Module A
    ModuleA A1 (
        .x(x),
        .y(y),
        .z(a1_out)
    );

    ModuleA A2 (
        .x(x),
        .y(y),
        .z(a2_out)
    );

    // Instances of Module B
    ModuleB B1 (
        .x(x),
        .y(y),
        .z(b1_out)
    );

    ModuleB B2 (
        .x(x),
        .y(y),
        .z(b2_out)
    );

    // OR gate combining outputs of A1 and B1
    assign or_out = a1_out | b1_out;

    // AND gate combining outputs of A2 and B2
    assign and_out = a2_out & b2_out;

    // XOR gate to produce final output z
    assign z = or_out ^ and_out;

endmodule

module ModuleA(
    input x,
    input y,
    output z
);
    assign z = (x ^ y) & x;
endmodule

module ModuleB(
    input x,
    input y,
    output z
);
    assign z = ~((x == 0 && y == 0) || (x == 1 && y == 0) || (x == 0 && y == 1 && !(x == 1 && y == 1)));
endmodule