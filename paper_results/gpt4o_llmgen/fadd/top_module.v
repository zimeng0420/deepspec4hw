module top_module (
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

    // Calculate sum using XOR operation
    assign sum = a ^ b ^ cin;

    // Calculate carry-out using the specified Boolean expression
    assign cout = (a & b) | (b & cin) | (cin & a);

endmodule