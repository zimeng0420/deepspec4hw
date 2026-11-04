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

    // Internal wires to hold the concatenated result
    wire [31:0] concatenated;

    // Concatenating input vectors a, b, c, d, e, f, and two 1 bits
    assign concatenated = {a, b, c, d, e, f, 2'b11};

    // Splitting the concatenated result into output vectors
    assign w = concatenated[31:24]; // Most significant 8 bits
    assign x = concatenated[23:16];
    assign y = concatenated[15:8];
    assign z = concatenated[7:0];    // Least significant 8 bits

endmodule