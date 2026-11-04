module top_module(
	input x,
	input y,
	output z);

	wire a1_z, a2_z, b1_z, b2_z, or_out, and_out;

	// Module A - Boolean function z = (x^y) & x
	module A(
		input x,
		input y,
		output z);
		assign z = (x ^ y) & x;
	endmodule

	// Module B - Implementing the waveform described behavior
	module B(
		input x,
		input y,
		output z);
		always @(*) begin
			case({x, y})
				2'b00: z = 1'b1;
				2'b01: z = 1'b0;
				2'b10: z = 1'b0;
				2'b11: z = 1'b1;
				default: z = 1'bx;
			endcase
		end
	endmodule

	// Instantiate Submodules
	A a1 (.x(x), .y(y), .z(a1_z));
	A a2 (.x(x), .y(y), .z(a2_z));
	B b1 (.x(x), .y(y), .z(b1_z));
	B b2 (.x(x), .y(y), .z(b2_z));

	// Logic Connections
	assign or_out = a1_z | b1_z;
	assign and_out = a2_z & b2_z;

	// Final XOR output
	assign z = or_out ^ and_out;

endmodule