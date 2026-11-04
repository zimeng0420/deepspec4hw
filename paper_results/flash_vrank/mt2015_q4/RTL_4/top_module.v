module top_module(
    input x,
    input y,
    output z);

    wire a_out1, a_out2, b_out1, b_out2, or_out, and_out;

    // Module A implementation
    module A(input x, input y, output z);
        assign z = (x ^ y) & x;
    endmodule

    // Module B implementation (based on waveform)
    module B(input x, input y, output z);
        reg z_reg;

        always @(x, y) begin
            if (x == 0 && y == 0) z_reg <= 1;
            else if (x == 1 && y == 0) z_reg <= 0;
            else if (x == 0 && y == 1) z_reg <= 0;
            else if (x == 1 && y == 1) z_reg <= 1;
            else z_reg <= 0; // Default to zero if cases are not matched
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

    // Final XOR gate
    assign z = or_out ^ and_out;

endmodule