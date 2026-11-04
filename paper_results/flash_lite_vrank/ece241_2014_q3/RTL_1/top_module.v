module top_module (
	input c,
	input d,
	output [3:0] mux_in
);

	wire sel0, sel1, sel2, sel3;

	// Calculate the inputs for the 4-to-1 mux

	// mux_in[0]: ab = 00
	assign sel0 = (c & d) | (~c & d) | (~c & ~d); //Equivalent to c'd + cd' + c'd' --> c' + d' 

	// mux_in[1]: ab = 01
	assign sel1 = 0; // always 0

	// mux_in[2]: ab = 11
	assign sel2 = (c & d) | (c & ~d); // c 

	// mux_in[3]: ab = 10
	assign sel3 = (c & d) | (~c & d) | (c & ~d); //Equivalent to c'd + cd' + cd  --> d + c

	assign mux_in[0] = sel0;
	assign mux_in[1] = sel1;
	assign mux_in[2] = sel2;
	assign mux_in[3] = sel3;
endmodule