module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

wire c_d; // Intermediate wire for c + d
wire mux1_out; // Output of 2-to-1 MUX for mux_in[2]

// 2-to-1 MUX for mux_in[2] = c + d
assign mux1_out = (d) ? 1'b1 : c; // if d is 1, output 1 else output c

assign mux_in[0] = 1'b0; // mux_in[0] = 0 (for ab = 00)
assign mux_in[1] = c;    // mux_in[1] = c (for ab = 01)
assign mux_in[2] = mux1_out; // mux_in[2] = c + d (for ab = 11)
assign mux_in[3] = c;    // mux_in[3] = c (for ab = 10)

endmodule