module top_module (
	input in1,
	input in2,
	input in3,
	output logic out
);

	// Intermediate wire for the output of the XNOR gate
	logic xnor_out;

	// XNOR gate logic
	assign xnor_out = ~(in1 ^ in2);

	// XOR gate logic using the XNOR output and in3
	assign out = xnor_out ^ in3;

endmodule