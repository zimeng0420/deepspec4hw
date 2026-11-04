module top_module (
	input a,
	input b,
	output sum,
	output cout
);

    assign sum = a ^ b;   // XOR Gate for Sum
    assign cout = a & b;  // AND Gate for Carry-out

endmodule