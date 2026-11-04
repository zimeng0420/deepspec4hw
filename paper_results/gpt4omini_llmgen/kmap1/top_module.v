module top_module(
    input a, 
    input b,
    input c,
    output out
);
    wire ab_not, ac, bc;

    // Intermediate signals
    assign ab_not = ~(a & b);       // a' b'
    assign ac = a & c;              // a c
    assign bc = b & c;              // b c

    // Final output logic based on the Karnaugh map.
    assign out = ab_not & b | ac | bc;

endmodule