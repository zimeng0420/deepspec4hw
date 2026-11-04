module top_module (
	input c,
	input d,
	output [3:0] mux_in
);

  // Assign the mux_in signals based on the K-map
  assign mux_in[0] = 1'b0;
  assign mux_in[1] = 1'b0;
  assign mux_in[2] = c & d;
  assign mux_in[3] = (c & ~d) | (~c & d);

endmodule