module top_module (
	input in1,
	input in2,
	input in3,
	output logic out
);

	// Intermediate signal for XNOR output
	wire xnor_out;

	// XNOR gate implementation
	assign xnor_out = ~(in1 ^ in2);

	// XOR gate implementation using the output of the XNOR gate and in3
	assign out = xnor_out ^ in3;

endmodule