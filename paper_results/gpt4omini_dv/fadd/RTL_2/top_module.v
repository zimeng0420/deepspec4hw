module top_module (
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    wire s1, c1;

    assign s1 = a ^ b;         // First half adder
    assign c1 = a & b;         // Carry out from first half adder
    assign sum = s1 ^ cin;     // Final sum from second half adder
    assign cout = c1 | (cin & s1); // Carry out logic

endmodule