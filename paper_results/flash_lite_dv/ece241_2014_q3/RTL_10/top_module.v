module top_module(
    input c,
    input d,
    output [3:0] mux_in
);

  wire c_and_not_d;
  wire c_and_d;
  wire not_c_and_not_d;

  // mux_in[0] = c & !d
  assign c_and_not_d = c & ~d;
  assign mux_in[0] = c_and_not_d;

  // mux_in[1] = 0
  assign mux_in[1] = 1'b0;

  // mux_in[2] = c & d
  assign c_and_d = c & d;
  assign mux_in[2] = c_and_d;

  // mux_in[3] = (!c & !d) | (c & !d)
  assign not_c_and_not_d = ~c & ~d;
  assign mux_in[3] = (not_c_and_not_d) | (c & ~d);

endmodule