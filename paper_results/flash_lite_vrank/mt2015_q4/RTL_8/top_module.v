module top_module(
	input x,
	input y,
	output z);

	wire a1_out, a2_out, b1_out, b2_out, or_out, and_out;

	// Module A instantiation
	module_a a1 (
		.x(x),
		.y(y),
		.z(a1_out)
	);
	
	module_a a2 (
		.x(x),
		.y(y),
		.z(a2_out)
	);

	// Module B instantiation
	module_b b1 (
		.x(x),
		.y(y),
		.z(b1_out)
	);

	module_b b2 (
		.x(x),
		.y(y),
		.z(b2_out)
	);

	// Intermediate logic
	assign or_out = a1_out | b1_out;
	assign and_out = a2_out & b2_out;

	// Final XOR
	assign z = or_out ^ and_out;

endmodule

module module_a(
	input x,
	input y,
	output z
);
	assign z = (x ^ y) & x;
endmodule

module module_b(
	input x,
	input y,
	output z
);
	reg z_reg;
	always @(x or y) begin
		case ({x, y})
			2'b00: z_reg = 1;
			2'b10: z_reg = 0;
			2'b01: z_reg = 0;
			2'b11: z_reg = 1;
			default: z_reg = 0;
		endcase
	end
	assign z = z_reg;
endmodule