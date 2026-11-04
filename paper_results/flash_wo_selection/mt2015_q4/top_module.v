module top_module(
    input x,
    input y,
    output z);

    // Module A: z = (x^y) & x
    module module_a(input x, input y, output z);
        assign z = (x ^ y) & x;
    endmodule

    // Module B: Implements the function defined by the waveform
    module module_b(input x, input y, output z);
        assign z = (~x & ~y) | (x & y); // Equivalent to XNOR
    endmodule

    wire a1_out, a2_out, b1_out, b2_out, or1_out, and1_out;

    // Instantiate Module A twice
    module_a a1 (x, y, a1_out);
    module_a a2 (x, y, a2_out);

    // Instantiate Module B twice
    module_b b1 (x, y, b1_out);
    module_b b2 (x, y, b2_out);

    // OR gate
    assign or1_out = a1_out | b1_out;

    // AND gate
    assign and1_out = a2_out & b2_out;

    // XOR gate
    assign z = or1_out ^ and1_out;

endmodule