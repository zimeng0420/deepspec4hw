module top_module (
    input a,
    input b,
    output sum,
    output cout
);

assign sum = a ^ b;  // Sum output
assign cout = a & b; // Carry-out output

endmodule