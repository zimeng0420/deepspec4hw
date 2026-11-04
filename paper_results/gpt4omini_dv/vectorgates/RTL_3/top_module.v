module top_module(
	input [2:0] a, 
	input [2:0] b, 
	output [2:0] out_or_bitwise,
	output out_or_logical,
	output [5:0] out_not
);

	// Bitwise OR operation
	assign out_or_bitwise = a | b; // Each bit of a is ORed with the corresponding bit of b

	// Logical OR operation
	assign out_or_logical = |{a, b}; // Reduction OR to check if any bit in a or b is high

	// NOT operation
	assign out_not[2:0] = ~a; // Inverse of a in the lower half
	assign out_not[5:3] = ~b; // Inverse of b in the upper half

endmodule