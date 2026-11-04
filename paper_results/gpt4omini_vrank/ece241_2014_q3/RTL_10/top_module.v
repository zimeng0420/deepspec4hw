module top_module (
	input c,
	input d,
	output [3:0] mux_in
);

	wire a, b;
	wire w1, w2, w3;

	assign a = c;
	assign b = d;

	// mux_in[0] = 0
	assign mux_in[0] = 0;

	// mux_in[1] = c'
	assign mux_in[1] = ~c & d;
	
	// mux_in[2] = (c & d') | (c & d)
	assign w1 = c & ~d; // when c=1 and d=0
	assign w2 = c & d;  // when c=1 and d=1
	assign mux_in[2] = w1 | w2;

	// mux_in[3] = (c' & d') | (c' & d) | (c & d)
	assign w3 = ~c & ~d; // when c=0 and d=0
	assign mux_in[3] = w3 | w2;

endmodule