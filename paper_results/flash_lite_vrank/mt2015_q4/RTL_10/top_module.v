module top_module(
	input x,
	input y,
	output z);

	wire a1_out, b1_out, a2_out, b2_out, or_out, and_out;

	// Module A
	module A (input x, input y, output z);
		assign z = (x ^ y) & x;
	endmodule

	// Module B
	module B (input x, input y, output z);
		reg z_reg;
		always @(x or y) begin
			case({x, y})
				2'b00: z_reg = 1'b1;
				2'b10: z_reg = 1'b0;
				2'b01: z_reg = 1'b0;
				2'b11: z_reg = 1'b1;
				default: z_reg = 1'b0;
			endcase
		end
		assign z = z_reg;
	endmodule

	// Instantiate submodules
	A a1 (x, y, a1_out);
	B b1 (x, y, b1_out);
	A a2 (x, y, a2_out);
	B b2 (x, y, b2_out);

	// Logic gates
	assign or_out = a1_out | b1_out;
	assign and_out = a2_out & b2_out;
	assign z = or_out ^ and_out;

endmodule