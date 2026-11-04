module top_module (
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

    assign sum = a ^ b ^ cin;        // XOR operation for sum
    assign cout = (a & b) | (b & cin) | (cin & a); // OR operation for carry-out

endmodule