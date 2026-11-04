module top_module (
    input a,
    input b,
    output sum,
    output cout
);
    assign sum = a ^ b; // Sum output (S = A XOR B)
    assign cout = a & b; // Carry-out output (Cout = A AND B)
endmodule