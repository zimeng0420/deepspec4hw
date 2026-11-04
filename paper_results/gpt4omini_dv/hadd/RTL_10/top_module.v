module top_module (
    input a,
    input b,
    output sum,
    output cout
);

assign sum = a ^ b;  // Sum output: A XOR B
assign cout = a & b; // Carry-out output: A AND B

endmodule