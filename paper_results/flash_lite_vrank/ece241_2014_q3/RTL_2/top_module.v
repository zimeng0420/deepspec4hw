module top_module (
	input c,
	input d,
	output [3:0] mux_in
);

	wire s0, s1, s2, s3;

	// Implement mux_in[0]
	assign s0 = (c & d) | (c & ~d); // c

	// Implement mux_in[1]
	assign s1 = 0;

	// Implement mux_in[2]
	assign s2 = (c & d) | (c & ~d); // c

	// Implement mux_in[3]
	assign s3 = (c & ~d) | (~c & ~d) | (c & d) | (~c & d) ;  // 1;

	assign mux_in[0] = s0;
	assign mux_in[1] = s1;
	assign mux_in[2] = s2;
	assign mux_in[3] = s3;

endmodule