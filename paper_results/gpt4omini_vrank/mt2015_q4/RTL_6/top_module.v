module top_module(
    input x,
    input y,
    output z
);
    
    wire a1_out, a2_out, b1_out, b2_out;
    wire or_out, and_out;

    // Module A
    assign a1_out = (x ^ y) & x;
    assign a2_out = (x ^ y) & x;

    // Module B
    assign b1_out = (x == 0 && y == 0) || (x == 1 && y == 1);
    assign b2_out = (x == 0 && y == 0) || (x == 1 && y == 1);

    // OR and AND gates
    assign or_out = a1_out | b1_out;
    assign and_out = a2_out & b2_out;

    // Final output
    assign z = or_out ^ and_out;

endmodule