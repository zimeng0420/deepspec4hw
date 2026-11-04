module top_module(
    input x,
    input y,
    output z);

    wire a_out1, a_out2, b_out1, b_out2, or_out, and_out;

    // Module A instantiation
    module_a a1 (
        .x(x),
        .y(y),
        .z(a_out1)
    );

    module_a a2 (
        .x(x),
        .y(y),
        .z(a_out2)
    );

    // Module B instantiation
    module_b b1 (
        .x(x),
        .y(y),
        .z(b_out1)
    );

    module_b b2 (
        .x(x),
        .y(y),
        .z(b_out2)
    );

    // OR gate
    assign or_out = a_out1 | b_out1;

    // AND gate
    assign and_out = a_out2 & b_out2;

    // XOR gate
    assign z = or_out ^ and_out;

endmodule

module module_a(
    input x,
    input y,
    output z);

    assign z = (x^y) & x;

endmodule

module module_b(
    input x,
    input y,
    output z);

    reg z;

    always @(x, y) begin
        case ({x, y})
            2'b00: z = 1;
            2'b01: z = 0;
            2'b10: z = 0;
            2'b11: z = 1;
            default: z = 1'bx;
        endcase
    end

endmodule