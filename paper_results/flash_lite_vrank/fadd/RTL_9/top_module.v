module top_module (
	input a,
	input b,
	input cin,
	output cout,
	output sum
);

	wire s1, c1, c2;

	xor u1 (s1, a, b);
	xor u2 (sum, s1, cin);

	and u3 (c1, a, b);
	and u4 (c2, s1, cin);

	or u5 (cout, c1, c2);

endmodule