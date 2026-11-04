module top_module(
    input x,
    input y,
    output z
);

    wire zA1, zA2, zB1, zB2;
    wire or_out, and_out;

    module_A A1 (
        .x(x),
        .y(y),
        .z(zA1)
    );

    module_A A2 (
        .x(x),
        .y(y),
        .z(zA2)
    );

    module_B B1 (
        .x(x),
        .y(y),
        .z(zB1)
    );

    module_B B2 (
        .x(x),
        .y(y),
        .z(zB2)
    );

    or or_gate (or_out, zA1, zB1);
    and and_gate (and_out, zA2, zB2);
    xor xor_gate (z, or_out, and_out);

endmodule

module module_A (
    input x,
    input y,
    output z
);
    assign z = (x ^ y) & x;
endmodule

module module_B (
    input x,
    input y,
    output reg z
);
    always @(*) begin
        case ({x, y})
            2'b00: z = 1;
            2'b11: z = 1;
            default: z = 0;
        endcase
    end
endmodule