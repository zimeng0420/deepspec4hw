module top_module (
	input c,
	input d,
	output [3:0] mux_in
);

  wire sel_0;
  wire sel_1;
  wire sel_2;
  wire sel_3;

  // mux_in[0] = 0
  assign sel_0 = 1'b0;

  // mux_in[1] = 0
  assign sel_1 = 1'b0;

  // mux_in[2] = d
  assign sel_2 = d;
  
  // mux_in[3] = d
  assign sel_3 = d;
  

  assign mux_in[0] = sel_0;
  assign mux_in[1] = sel_1;
  assign mux_in[2] = sel_2;
  assign mux_in[3] = sel_3;

endmodule