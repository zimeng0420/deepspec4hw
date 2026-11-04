module top_module(
    input c,
    input d,
    output [3:0] mux_in
);

  // Internal signals
  wire mux_in0_input0;
  wire mux_in2_input0;
  wire mux_in3_input0;

  // Logic for mux_in[0]
  assign mux_in0_input0 = 0;
  assign mux_in[0] = (d) ? mux_in0_input0 : c;

  // Logic for mux_in[1]
  assign mux_in[1] = 1'b0;

  // Logic for mux_in[2]
  assign mux_in2_input0 = 0;
  assign mux_in[2] = (d) ? c : mux_in2_input0;


  // Logic for mux_in[3]
  assign mux_in3_input0 = ~c;
  assign mux_in[3] = (d) ? c : mux_in3_input0;


endmodule