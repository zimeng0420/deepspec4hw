module top_module(
	input x,
	input y,
	output z
);

	wire z_A1, z_A2, z_B1, z_B2;
	wire or_output, and_output;

	// Module A implementation
	assign z_A1 = (x ^ y) & x;
	assign z_A2 = (x ^ y) & x;

	// Module B implementation based on the waveform
	assign z_B1 = (x == 0 && y == 0) || (x == 1 && y == 1);
	assign z_B2 = (x == 0 && y == 0) || (x == 1 && y == 1);

	// OR gate
	assign or_output = z_A1 | z_B1;
	
	// AND gate
	assign and_output = z_A2 & z_B2;

	// Final XOR gate
	assign z = or_output ^ and_output;

endmodule