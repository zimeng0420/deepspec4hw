module top_module(
    input c,
    input d,
    output [3:0] mux_in
);

  // Internal wires
  wire mux_in0_input0;
  wire mux_in2_input0;
  wire mux_in3_input0;

  // Implement mux_in[0] = (c & ~d)
  assign mux_in0_input0 = 0; // Input 0
  assign mux_in[0] = (d == 0) ? c : mux_in0_input0;

  // Implement mux_in[1] = 0
  assign mux_in[1] = 0;

  // Implement mux_in[2] = (c & d)
  assign mux_in2_input0 = 0;
  assign mux_in[2] = d ? c : mux_in2_input0;

  // Implement mux_in[3] = (~c & ~d) | (c & ~d)
  assign mux_in3_input0 = c;
  assign mux_in[3] = (d == 0) ? mux_in3_input0 : ~c;

endmodule