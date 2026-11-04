module top_module (
    input a,
    input b,
    output sum,
    output cout
);
    // Sum is the XOR of inputs a and b
    assign sum = a ^ b;
    // Cout is the AND of inputs a and b
    assign cout = a & b;
endmodule