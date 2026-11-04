module top_module(
	input x,
	input y,
	output z);

	// Internal wires
	wire a1_out, a2_out, b1_out, b2_out, or_out, and_out;

	// Module A instantiation
	module A(input x, input y, output z);
		assign z = (x ^ y) & x;
	endmodule

	// Module B instantiation
	module B(input x, input y, output z);
		always_comb begin
			case ({x, y})
				2'b00: z = 1'b1;
				2'b01: z = 1'b0;
				2'b10: z = 1'b0;
				2'b11: z = 1'b1;
				default: z = 1'b0; // Handle any unexpected input combinations (though not expected)
			endcase
		end
	endmodule

	A A1 (
		.x(x),
		.y(y),
		.z(a1_out)
	);

	A A2 (
		.x(x),
		.y(y),
		.z(a2_out)
	);

	B B1 (
		.x(x),
		.y(y),
		.z(b1_out)
	);

	B B2 (
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