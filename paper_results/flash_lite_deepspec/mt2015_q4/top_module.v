module top_module(
	input x,
	input y,
	output z);

	wire a1_out, a2_out, b1_out, b2_out, or_out, and_out;

	// Module A
	module a(input x, input y, output out);
		assign out = (x ^ y) & x;
	endmodule

	// Module B
	module b(input x, input y, output out);
		assign out = ((!x) & (!y)) | (x & y);
	endmodule

	a a1 (x, y, a1_out);
	a a2 (x, y, a2_out);
	b b1 (x, y, b1_out);
	b b2 (x, y, b2_out);

	assign or_out = a1_out | b1_out;
	assign and_out = a2_out & b2_out;
	assign z = or_out ^ and_out;

endmodule