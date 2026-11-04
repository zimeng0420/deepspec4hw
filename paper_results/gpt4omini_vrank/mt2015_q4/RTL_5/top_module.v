module top_module(
    input x,
    input y,
    output z
);
    wire a1_out, a2_out, b1_out, b2_out;
    wire or_out, and_out;

    // Module A implementation
    assign a1_out = (x ^ y) & x;
    assign a2_out = (x ^ y) & x;

    // Module B implementation
    assign b1_out = (~x & ~y) || (x & y);
    assign b2_out = (~x & ~y) || (x & y);

    // OR and AND gates
    assign or_out = a1_out | b1_out;
    assign and_out = a2_out & b2_out;

    // Final XOR gate
    assign z = or_out ^ and_out;

endmodule