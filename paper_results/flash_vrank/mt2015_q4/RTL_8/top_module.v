module top_module(
    input x,
    input y,
    output z);

    // Instantiate Module A
    wire a_out1, a_out2;
    module_A a1 (
        .x(x),
        .y(y),
        .z(a_out1)
    );
    module_A a2 (
        .x(x),
        .y(y),
        .z(a_out2)
    );

    // Instantiate Module B
    wire b_out1, b_out2;
    module_B b1 (
        .x(x),
        .y(y),
        .z(b_out1)
    );
    module_B b2 (
        .x(x),
        .y(y),
        .z(b_out2)
    );

    // Instantiate gates
    wire or_out, and_out;
    assign or_out = a_out1 | b_out1;
    assign and_out = a_out2 & b_out2;
    assign z = or_out ^ and_out;

endmodule

module module_A(
    input x,
    input y,
    output z);

    assign z = (x ^ y) & x;

endmodule

module module_B(
    input x,
    input y,
    output z);

    always@ (x, y) begin
        if (x == 0 && y == 0)
            z = 1;
        else if (x == 1 && y == 0)
            z = 0;
        else if (x == 0 && y == 1)
            z = 0;
        else if (x == 1 && y == 1)
            z = 1;
        else
            z = 1'bx; // Handle unknown inputs, shouldn't occur in example waveform
    end

endmodule