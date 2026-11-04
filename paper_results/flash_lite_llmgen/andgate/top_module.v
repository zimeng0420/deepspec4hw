module top_module(
	input a, 
	input b,
	output out
);

	// Assign the output to the AND of the inputs
	assign out = a & b;

endmodule