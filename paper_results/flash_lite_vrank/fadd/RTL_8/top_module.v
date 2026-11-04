module top_module (
	input a,
	input b,
	input cin,
	output cout,
	output sum
);

    wire sum_intermediate;
    wire carry1, carry2;

    // Calculate sum
    xor u1 (sum_intermediate, a, b);
    xor u2 (sum, sum_intermediate, cin);

    // Calculate carry-out
    and u3 (carry1, a, b);
    and u4 (carry2, sum_intermediate, cin);
    or u5 (cout, carry1, carry2);

endmodule