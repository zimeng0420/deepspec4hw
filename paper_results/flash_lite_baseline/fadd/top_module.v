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

    // Calculate sum
    xor u1 (sum_intermediate, a, b);
    xor u2 (sum, sum_intermediate, cin);

    // Calculate carry-out
    and u3 (carry_ab, a, b);
    and u4 (carry_in_sum, cin, sum_intermediate);
    or u5 (cout, carry_ab, carry_in_sum);

endmodule