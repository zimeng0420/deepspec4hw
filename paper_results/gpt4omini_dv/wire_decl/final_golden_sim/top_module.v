module top_module (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    wire and1_out; // Intermediate wire for first AND gate
    wire and2_out; // Intermediate wire for second AND gate

    // First AND gate
    and and1 (and1_out, a, b);
    
    // Second AND gate
    and and2 (and2_out, c, d);
    
    // OR gate combining the outputs of the two AND gates
    or or1 (out, and1_out, and2_out);
    
    // NOT gate for inverted output
    not not1 (out_n, out);

endmodule