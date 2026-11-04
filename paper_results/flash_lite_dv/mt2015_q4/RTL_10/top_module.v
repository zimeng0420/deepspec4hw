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
    output z
);
    always_comb
    begin
        case ({x, y})
            2'b00: z = 1'b1;
            2'b01: z = 1'b0;
            2'b10: z = 1'b0;
            2'b11: z = 1'b1;
            default: z = 1'b0; // Should not happen, but good practice
        endcase
    end
endmodule

module top_module (
    input x,
    input y,
    output z
);

    wire a1_out, a2_out, b1_out, b2_out, or_out, and_out;

    module_A A1 (x, y, a1_out);
    module_A A2 (x, y, a2_out);
    module_B B1 (x, y, b1_out);
    module_B B2 (x, y, b2_out);

    assign or_out = a1_out | b1_out;
    assign and_out = a2_out & b2_out;
    assign z = or_out ^ and_out;

endmodule