module top_module(
    input c,
    input d,
    output [3:0] mux_in
);

  wire mux_in0_in0;
  wire mux_in2_in0;
  wire mux_in3_in0;

  // mux_in[0] = (c & ~d)
  assign mux_in0_in0 = c;

  assign mux_in[0] = (d) ? 1'b0 : mux_in0_in0;


  // mux_in[1] = 0
  assign mux_in[1] = 1'b0;

  // mux_in[2] = (c & d)
  assign mux_in2_in0 = c;
  assign mux_in[2] = (d) ? mux_in2_in0 : 1'b0;


  // mux_in[3] = (~c & ~d) | (c & ~d)  which simplifies to ~d
  assign mux_in3_in0 = ~c;
  assign mux_in[3] = (d) ? c : mux_in3_in0;

endmodule