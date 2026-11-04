module top_module (
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

    // Calculate the sum
    assign sum = a ^ b ^ cin;

    // Calculate the carry-out
    assign cout = (a & b) | (cin & (a ^ b));

endmodule