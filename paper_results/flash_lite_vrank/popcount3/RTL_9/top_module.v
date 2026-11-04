module top_module (
	input [2:0] in,
	output [1:0] out
);

  // Calculate the population count
  assign out[0] = in[0] ^ in[1] ^ in[2]; // XOR operation to count odd number of 1s
  assign out[1] = (in[0] & in[1]) | (in[0] & in[2]) | (in[1] & in[2]); // Calculate number of pairs of 1s

  // Handle all 1s case. If out[0] is 1 and out[1] is 1, it means all inputs are 1
  // If all three inputs are 1s, the popcount is 3, represented as 2'b11.
  // else if out[1] == 1, it means exactly two of the inputs are 1, and output should be 2, which is 2'b10

  always @(*) begin
    if (in[0] && in[1] && in[2])
      out = 2'b11;
    else if (out[1] && !out[0])
        out = 2'b10;
    else if (out[0] && !out[1])
        out = 2'b01;
    else
        out = 2'b00;
  end
endmodule