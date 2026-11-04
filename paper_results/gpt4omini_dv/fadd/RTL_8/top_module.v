module top_module (
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

    wire s1, c1;

    assign s1 = a ^ b;          // First half adder: S1
    assign sum = s1 ^ cin;      // Final sum
    assign c1 = a & b;          // First half adder carry
    assign cout = c1 | (cin & s1); // Final carry-out

endmodule