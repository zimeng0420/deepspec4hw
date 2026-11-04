module top_module (
	input c,
	input d,
	output [3:0] mux_in
);

  wire out0, out1, out2, out3;

  // Implement the logic for each input of the 4-to-1 mux
  // mux_in[0]
  assign out0 = (c & d) | (~c & d);  // (cd) | (~cd) = d.  We can directly use 'd' as input.
  // mux_in[1]
  assign out1 = 1'b0; // output is always 0

  // mux_in[2]
  assign out2 = (c & ~d) | (~c & d); // XOR function
	
  // mux_in[3]
  assign out3 = (c & ~d) | (~c & d);


  assign mux_in[0] = out0;
  assign mux_in[1] = out1;
  assign mux_in[2] = out2;
  assign mux_in[3] = out3;

endmodule