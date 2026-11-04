module top_module (
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Intermediate signal for a XOR b
    wire axorb;
    
    // Compute a XOR b
    assign axorb = a ^ b;
    
    // Compute sum = (a XOR b) XOR cin
    assign sum = axorb ^ cin;
    
    // Compute cout = (a AND b) OR (cin AND (a XOR b))
    assign cout = (a & b) | (cin & axorb);
    
endmodule