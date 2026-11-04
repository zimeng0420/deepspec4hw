module top_module(
    input x,
    input y,
    output z
);

    // Module A: z = (x^y) & x
    wire a1_out, a2_out;
    module_a A1 (
        .x(x),
        .y(y),
        .z(a1_out)
    );
    module_a A2 (
        .x(x),
        .y(y),
        .z(a2_out)
    );
    
    // Module B: Defined by the given waveform
    wire b1_out, b2_out;
    module_b B1 (
        .x(x),
        .y(y),
        .z(b1_out)
    );
    module_b B2 (
        .x(x),
        .y(y),
        .z(b2_out)
    );

    wire or_out, and_out;
    
    // OR gate with outputs of the first A and B modules
    assign or_out = a1_out | b1_out;
    
    // AND gate with outputs of the second A and B modules
    assign and_out = a2_out & b2_out;

    // XOR gate with outputs of the OR and AND gates
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
    assign z = (x & y) | (~x & ~y); // Implements the observed waveform pattern
endmodule