module top_module (
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

    // Intermediate result for a XOR b
    wire ab_xor;

    // Calculate a XOR b
    assign ab_xor = a ^ b;
    
    // Calculate sum = (a XOR b) XOR cin
    assign sum = ab_xor ^ cin;
    
    // Calculate cout = (a AND b) OR (cin AND (a XOR b))
    assign cout = (a & b) | (cin & ab_xor);

endmodule