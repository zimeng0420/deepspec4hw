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

    // Module B
    module B(
        input x,
        input y,
        output z
    );
        reg z;
        always @(*) begin
            if ((x == 0 && y == 0) || (x == 1 && y == 1)) 
                z = 1;
            else 
                z = 0;
        end
    endmodule

    // Instantiate two A modules
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

    // Instantiate two B modules
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

    // OR gate for the first pair of outputs
    assign or_out = a1_out | b1_out;

    // AND gate for the second pair of outputs
    assign and_out = a2_out & b2_out;

    // Final XOR
    assign z = or_out ^ and_out;

endmodule