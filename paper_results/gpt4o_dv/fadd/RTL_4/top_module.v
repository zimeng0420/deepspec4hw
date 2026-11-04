module top_module (
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

    // Intermediate signal for a XOR b
    wire axorb;

    // XOR operation for sum calculation
    assign axorb = a ^ b;
    assign sum = axorb ^ cin;

    // AND and OR operations for carry-out calculation
    assign cout = (a & b) | (cin & axorb);

endmodule