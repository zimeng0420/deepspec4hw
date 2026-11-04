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
    and u1(and1_out, a, b);
    
    // Second AND gate
    and u2(and2_out, c, d);
    
    // OR gate
    or u3(out, and1_out, and2_out);
    
    // NOT gate
    not u4(out_n, out);

endmodule