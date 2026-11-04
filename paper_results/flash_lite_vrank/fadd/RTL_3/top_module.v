module top_module (
	input a,
	input b,
	input cin,
	output cout,
	output sum
);

	wire s1, c1, c2;

	// Half adder 1
	xor u1 (s1, a, b);
	and a1 (c1, a, b);

	// Half adder 2
	xor u2 (sum, s1, cin);
	and a2 (c2, s1, cin);

	// OR gate for carry-out
	or  o1 (cout, c1, c2);

endmodule