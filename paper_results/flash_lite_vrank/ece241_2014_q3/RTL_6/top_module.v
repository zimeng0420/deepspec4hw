module top_module (
	input c,
	input d,
	output [3:0] mux_in
);

  wire out0, out1, out2, out3;

  // Implementations for mux_in[0]
  assign out0 = (c & d) | (~c & ~d); // Reduced expression: c'd' + cd
  // mux_in[0] can be implemented with a single 2-to-1 mux

  // Implementations for mux_in[1]
  assign out1 = 0;
  // mux_in[1] is 0

  // Implementations for mux_in[2]
  assign out2 = (c & d) | (~c & ~d);  // Reduced expression: c'd' + cd
  // mux_in[2] is the same as mux_in[0]

  // Implementations for mux_in[3]
  assign out3 = (c & ~d) | (~c & ~d) ;  // Reduced Expression: c'd' + c'd
  // mux_in[3] can be implemented with a single 2-to-1 mux

  assign mux_in[0] = out0;
  assign mux_in[1] = out1;
  assign mux_in[2] = out2;
  assign mux_in[3] = out3;
  
endmodule