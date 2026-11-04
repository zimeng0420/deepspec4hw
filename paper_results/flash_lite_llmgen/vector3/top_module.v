module top_module (
	input [4:0] a,
	input [4:0] b,
	input [4:0] c,
	input [4:0] d,
	input [4:0] e,
	input [4:0] f,
	output [7:0] w,
	output [7:0] x,
	output [7:0] y,
	output [7:0] z
);

	// Internal wires
	wire [29:0] concat_in;
	wire [31:0] concat_out;

	// Concatenate the input vectors
	assign concat_in = {f, e, d, c, b, a};

	// Concatenate the input vectors with two '1' bits
	assign concat_out = {concat_in, 2'b11};

	// Assign output vectors
	assign w = concat_out[31:24]; // MSB bits
	assign x = concat_out[23:16];
	assign y = concat_out[15:8];
	assign z = concat_out[7:0];  // LSB bits

endmodule