module top_module(
    input x,
    input y,
    output z
);

    wire a_out1, a_out2, b_out1, b_out2, or_out, and_out;

    // Module A implementation: z = (x^y) & x
    module A(input x, input y, output z);
        assign z = (x ^ y) & x;
    endmodule

    // Module B implementation based on waveform
    module B(input x, input y, output z);
        reg z_reg;
        always @(x, y) begin
            case ({x, y})
                2'b00: z_reg <= 1;
                2'b01: z_reg <= 0;
                2'b10: z_reg <= 0;
                2'b11: z_reg <= 1;
                default: z_reg <= 0; // Shouldn't happen, but good practice
            endcase
        end
        assign z = z_reg;
    endmodule

    // Instantiate submodules
    A a1(x, y, a_out1);
    A a2(x, y, a_out2);
    B b1(x, y, b_out1);
    B b2(x, y, b_out2);

    // Instantiate gates
    assign or_out = a_out1 | b_out1;
    assign and_out = a_out2 & b_out2;

    // Final XOR
    assign z = or_out ^ and_out;

endmodule