module top_module (
    input a,
    input b,
    output sum,
    output cout
);

assign sum = a ^ b;    // Sum = A XOR B
assign cout = a & b;   // Carry-out = A AND B

endmodule