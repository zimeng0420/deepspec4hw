module top_module (
	input a,
	input b,
	input cin,
	output cout,
	output sum
);

	wire sum_intermediate;
	wire carry_ab;
	wire carry_in_sum;

	// Half Adder for a and b
	assign sum_intermediate = a ^ b;
	assign carry_ab = a & b;

	// Half Adder for sum_intermediate and cin
	assign sum = sum_intermediate ^ cin;
	assign carry_in_sum = sum_intermediate & cin;

	// Carry-out
	assign cout = carry_ab | carry_in_sum;

endmodule