module top_module (
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

    // Intermediate wire to hold the XOR of a and b
    wire xor_ab;

    // Calculate the intermediate XOR result
    assign xor_ab = a ^ b;

    // Calculate the sum using the XOR operation
    assign sum = xor_ab ^ cin;

    // Calculate the carry-out using AND and OR operations
    assign cout = (a & b) | (cin & xor_ab);

endmodule