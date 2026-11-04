module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

wire mux1_out, mux2_out;
wire mux3_out, mux4_out;

// 2-to-1 MUX for mux_in[1] (c)
assign mux_in[1] = c;

// 2-to-1 MUX for mux_in[2] (c + d)
assign mux2_out = c | d; // mux_in[2] needs c + d

// 2-to-1 MUX for mux_in[3] (c)
assign mux_in[3] = c;

// Connection to mux_in[0], which is 0
assign mux_in[0] = 1'b0;

// Assign mux_in[2] to the output of the 4-to-1 MUX based on a and b
assign mux_in[2] = mux2_out;

// Overall mux_in outputs
assign mux_in = {mux_in[3], mux_in[2], mux_in[1], mux_in[0]};

endmodule