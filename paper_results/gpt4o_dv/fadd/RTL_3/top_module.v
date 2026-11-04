module top_module (
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Intermediate signal
    wire xor_ab;
    
    // Compute a XOR b
    assign xor_ab = a ^ b;
    
    // Final sum output
    assign sum = xor_ab ^ cin;
    
    // Compute carry out
    assign cout = (a & b) | (cin & xor_ab);

endmodule