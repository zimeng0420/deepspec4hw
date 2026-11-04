module top_module (
    input a,
    input b,
    output sum,
    output cout
);

// Internal logic for Half Adder
assign sum = a ^ b;   // Sum is the result of the XOR operation between inputs a and b
assign cout = a & b;  // Carry-out is the result of the AND operation between inputs a and b

endmodule