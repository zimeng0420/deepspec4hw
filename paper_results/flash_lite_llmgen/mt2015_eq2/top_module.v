module top_module(
	input [1:0] A,
	input [1:0] B,
	output z);

	// Method 1: Using equality operator (most straightforward)
	assign z = (A == B);

	// Method 2: Using bitwise comparison and AND gates (more explicit)
	// wire eq_bit1;
	// wire eq_bit0;
	// assign eq_bit1 = ~(A[1] ^ B[1]); // XOR then NOT (XNOR)
	// assign eq_bit0 = ~(A[0] ^ B[0]); // XOR then NOT (XNOR)
	// assign z = eq_bit1 & eq_bit0;

endmodule