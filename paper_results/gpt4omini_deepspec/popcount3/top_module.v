module top_module (
	input [2:0] in,
	output [1:0] out
);

assign out[0] = in[0] ^ in[1] ^ in[2]; // Calculate the parity for the count of 1's (LSB)
assign out[1] = (in[0] & in[1]) | (in[0] & in[2]) | (in[1] & in[2]); // Calculate the number of pairs (MSB)

endmodule