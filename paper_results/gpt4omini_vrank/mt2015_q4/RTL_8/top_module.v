module top_module(
    input x,
    input y,
    output z
);
    
    wire a1_out, a2_out, b1_out, b2_out;
    wire or_out, and_out;

    // Module A: z = (x ^ y) & x
    module A (
        input x,
        input y,
        output z
    );
        assign z = (x ^ y) & x;
    endmodule
    
    // Module B
    module B (
        input x,
        input y,
        output z
    );
        assign z = (x == 0 && y == 0) ? 1 :
                   (x == 1 && y == 0) ? 0 :
                   (x == 0 && y == 1) ? 0 :
                   (x == 1 && y == 1) ? 1 : 1;
    endmodule

    // Instances of module A
    A a1 (
        .x(x),
        .y(y),
        .z(a1_out)
    );

    A a2 (
        .x(x),
        .y(y),
        .z(a2_out)
    );

    // Instances of module B
    B b1 (
        .x(x),
        .y(y),
        .z(b1_out)
    );

    B b2 (
        .x(x),
        .y(y),
        .z(b2_out)
    );

    // OR and AND gates
    assign or_out = a1_out | b1_out;
    assign and_out = a2_out & b2_out;

    // Final output
    assign z = or_out ^ and_out;

endmodule