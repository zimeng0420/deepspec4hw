module top_module(
	input x,
	input y,
	output z
);

	wire A1_out, A2_out, B1_out, B2_out;
	wire or_out, and_out;

	// Module A
	assign A1_out = (x ^ y) & x;
	assign A2_out = (x ^ y) & x;

	// Module B
	assign B1_out = (x == 0 && y == 0) ? 1 :
	                (x == 1 && y == 0) ? 0 :
	                (x == 0 && y == 1) ? 0 :
	                (x == 1 && y == 1) ? 1 :
	                0; // Default case

	assign B2_out = (x == 0 && y == 0) ? 1 :
	                (x == 1 && y == 0) ? 0 :
	                (x == 0 && y == 1) ? 0 :
	                (x == 1 && y == 1) ? 1 :
	                0; // Default case

	// Logic gates
	assign or_out = A1_out | B1_out;
	assign and_out = A2_out & B2_out;

	// Final output
	assign z = or_out ^ and_out;

endmodule