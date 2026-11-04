module top_module (
	input in1,
	input in2,
	output logic out
);

  // Implementation using the logical NOT and OR operators.
  assign out = ~(in1 | in2);

  // Alternative implementation using a conditional operator (ternary operator).  This is functionally equivalent.
  // assign out = (in1 | in2) ? 1'b0 : 1'b1;

endmodule