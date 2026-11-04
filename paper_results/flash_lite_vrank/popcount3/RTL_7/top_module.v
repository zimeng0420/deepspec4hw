module top_module (
	input [2:0] in,
	output [1:0] out
);

  // Calculate the population count using a combination of XOR and AND gates.
  // The result is a 2-bit output, capable of representing values from 0 to 3.

  wire w1, w2, w3, w4;

  assign w1 = in[0] ^ in[1];
  assign w2 = in[0] & in[1];
  assign w3 = w1 ^ in[2];
  assign w4 = w2 | (in[2] & w1); // Optimize for speed using a single OR gate

  assign out[0] = w3; // LSB: odd parity
  assign out[1] = w4; // MSB: determines the population count greater than 1.

endmodule