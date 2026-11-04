module top_module (
	input [2:0] in,
	output [1:0] out
);

	wire and0, and1, and2, and3, and4, and5;

	assign and0 = in[0] & in[1];
	assign and1 = in[0] & in[2];
	assign and2 = in[1] & in[2];

	assign and3 = and0 | and1;
	assign and4 = and0 | and2;
	assign and5 = and1 | and2;

	assign out[0] = in[0] ^ in[1] ^ in[2];
	assign out[1] = and3 | and4 | and5;

endmodule