module top_module (
	input [2:0] in,
	output [1:0] out
);

  wire w1, w2, w3;

  assign w1 = in[0] + in[1];
  assign w2 = w1 + in[2];

  assign out = w2;
  
endmodule