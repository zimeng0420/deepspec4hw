module top_module(
    input x,
    input y,
    output z
);

    wire a1_out, a2_out, b1_out, b2_out;
    wire or_out, and_out;

    // Module A
    module A(
        input x,
        input y,
        output z
    );
        assign z = (x ^ y) & x;
    endmodule

    // Module B implementation
    module B(
        input x,
        input y,
        output z
    );
        assign z = ((x == 0) && (y == 0)) ? 1 :
                   ((x == 1) && (y == 1)) ? 1 : 0;
    endmodule

    // Instantiation of both A and B submodules
    A A1 (.x(x), .y(y), .z(a1_out));
    A A2 (.x(x), .y(y), .z(a2_out));
    B B1 (.x(x), .y(y), .z(b1_out));
    B B2 (.x(x), .y(y), .z(b2_out));

    // OR gate
    assign or_out = a1_out | b1_out;

    // AND gate
    assign and_out = a2_out & b2_out;

    // XOR gate for final output
    assign z = or_out ^ and_out;

endmodule