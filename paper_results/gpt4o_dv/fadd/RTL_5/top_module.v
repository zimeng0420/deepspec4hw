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

    // Compute sum using XOR gates
    assign sum = xor_ab ^ cin;

    // Compute carry-out using AND and OR gates
    assign cout = (a & b) | (cin & xor_ab);

endmodule