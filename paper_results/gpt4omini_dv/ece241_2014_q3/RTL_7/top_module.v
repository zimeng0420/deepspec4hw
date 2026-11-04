module top_module (
    input c,
    input d,
    output [3:0] mux_in
);
    wire mux1_out, mux2_out, mux3_out;

    // 2-to-1 mux for mux_in[1] = c
    assign mux_in[1] = c;

    // 2-to-1 mux for mux_in[2] = c + d
    assign mux2_out = c | d; // c + d

    // 2-to-1 mux for mux_in[3] = c
    assign mux_in[3] = c;

    // from K-map
    assign mux_in[0] = 0; // constant 0 for ab = 00

    // Connect mux_in[2] to mux2_out (c + d)
    assign mux_in[2] = mux2_out;

endmodule