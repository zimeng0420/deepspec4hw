module top_module (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
    );
    
    // Intermediate wires for connection between AND and OR gates
    wire and1_out;
    wire and2_out;
    
    // First layer: Two AND gates
    and and_gate1 (and1_out, a, b);
    and and_gate2 (and2_out, c, d);
    
    // Second layer: OR gate
    or or_gate (out, and1_out, and2_out);
    
    // Inverted output
    not not_gate (out_n, out);

endmodule