module top_module(
    input x,
    input y,
    output z
);
    // Module A
    wire a1_out, a2_out;
    wire b1_out, b2_out;

    assign a1_out = (x ^ y) & x;  // z = (x^y) & x for module A
    assign a2_out = (x ^ y) & x;  // for the second instance of module A
    
    // Module B
    assign b1_out = (x == 0 && y == 0) || (x == 1 && y == 1);  // logic to match the waveform for B
    assign b2_out = (x == 0 && y == 0) || (x == 1 && y == 1);  // for second instance of module B

    // Intermediate signals
    wire or_out;
    wire and_out;

    // OR gate
    assign or_out = a1_out | b1_out;

    // AND gate
    assign and_out = a2_out & b2_out;

    // Final output
    assign z = or_out ^ and_out;

endmodule