module top_module (
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    wire s1, c1;

    // First half adder
    assign s1 = a ^ b;      // Sum of A and B
    assign c1 = a & b;      // Carry from A and B

    // Second half adder
    assign sum = s1 ^ cin;  // Final sum
    assign cout = c1 | (cin & s1); // Final carry-out
endmodule