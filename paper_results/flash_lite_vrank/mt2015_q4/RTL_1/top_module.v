module top_module(
	input x,
	input y,
	output z);

	wire a1_out, a2_out, b1_out, b2_out;
	wire or_out, and_out;

	// Module A instantiation
	module_A a1 (
		.x(x),
		.y(y),
		.z(a1_out)
	);

	module_A a2 (
		.x(x),
		.y(y),
		.z(a2_out)
	);

	// Module B instantiation
	module_B b1 (
		.x(x),
		.y(y),
		.z(b1_out)
	);

	module_B b2 (
		.x(x),
		.y(y),
		.z(b2_out)
	);

	// OR gate
	assign or_out = a1_out | b1_out;

	// AND gate
	assign and_out = a2_out & b2_out;

	// XOR gate
	assign z = or_out ^ and_out;

endmodule

// Module A definition
module module_A(
	input x,
	input y,
	output z
);

	assign z = (x ^ y) & x;

endmodule

// Module B definition
module module_B(
	input x,
	input y,
	output z
);
	reg z_reg;

	always @(x or y) begin
		if (x == 0 && y == 0)
			z_reg = 1;
		else if (x == 1 && y == 0)
			z_reg = 0;
		else if (x == 0 && y == 1)
			z_reg = 0;
		else if (x == 1 && y == 1)
			z_reg = 1;
		else
			z_reg = 0; //default state, should not happen

	end

	assign z = z_reg;

endmodule