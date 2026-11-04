module top_module(
    input x,
    input y,
    output z
);

    wire a_out1, a_out2, b_out1, b_out2, or_out, and_out;

    // Instantiate A modules
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

    // Instantiate B modules
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

    // Instantiate OR gate
    assign or_out = a_out1 | b_out1;

    // Instantiate AND gate
    assign and_out = a_out2 & b_out2;

    // Instantiate XOR gate
    assign z = or_out ^ and_out;

endmodule

module module_a(
    input x,
    input y,
    output z
);

    assign z = (x ^ y) & x;

endmodule

module module_b(
    input x,
    input y,
    output z
);

    reg z_reg;

    always @(x or y) begin
        case ({x, y})
            2'b00: z_reg = 1;
            2'b01: z_reg = 0;
            2'b10: z_reg = 0;
            2'b11: z_reg = 1;
            default: z_reg = 1'bx; // Should not happen, but good practice
        endcase
    end

    assign z = z_reg;

endmodule