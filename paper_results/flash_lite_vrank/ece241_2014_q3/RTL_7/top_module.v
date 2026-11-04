module top_module (
	input c,
	input d,
	output [3:0] mux_in
);

	wire in0, in1, in2, in3;

	// Calculate inputs for the 4-to-1 mux
	assign in0 = (c & d) | (~c & ~d);  // Equivalent to (cd == 00) OR (cd == 11)
	assign in1 = 0; // Equivalent to (cd == 01)
	assign in2 = (c & d);  // Equivalent to (cd == 11)
	assign in3 = (c & ~d) | (~c & ~d); // Equivalent to (cd == 00) OR (cd == 10)
	
	assign mux_in[0] = in0;
	assign mux_in[1] = in1;
	assign mux_in[2] = in2;
	assign mux_in[3] = in3;
	
endmodule