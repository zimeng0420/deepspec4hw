module top_module (
	input a,
	input b,
	input cin,
	output cout,
	output sum
);

	wire sum_ab, carry_ab;

	// Half adder for a and b
	assign sum_ab = a ^ b;
	assign carry_ab = a & b;

	// Second half adder with sum_ab and cin
	assign sum = sum_ab ^ cin;
	assign cout = carry_ab | (sum_ab & cin);

endmodule