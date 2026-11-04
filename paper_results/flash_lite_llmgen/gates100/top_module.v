module top_module (
	input [99:0] in,
	output out_and,
	output out_or,
	output out_xor
);

  // AND operation
  assign out_and = &in;  // Built-in AND reduction operator

  // OR operation
  assign out_or = |in;   // Built-in OR reduction operator

  // XOR operation
  assign out_xor = ^in;  // Built-in XOR reduction operator

endmodule