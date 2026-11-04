module top_module (
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

    wire s1, c1;

    // First half adder
    assign s1 = a ^ b; // S1 = A XOR B
    assign c1 = a & b; // C1 = A AND B

    // Second half adder
    assign sum = s1 ^ cin; // Sum = S1 XOR Cin

    // Carry-out
    assign cout = c1 | (cin & s1); // Cout = C1 OR (Cin AND S1)

endmodule