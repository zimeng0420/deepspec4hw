module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

    wire mux1_out, mux2_out;

    // Implementing mux_in[1] = c (for ab = 01)
    assign mux_in[1] = c;

    // Implementing mux_in[2] = c + d (for ab = 11)
    assign mux2_out = (c | d);

    // Implementing mux_in[3] = c (for ab = 10)
    assign mux_in[3] = c;

    // mux_in[0] = 0 (for ab = 00)
    assign mux_in[0] = 0;

    // Combine the outputs
    assign mux_in[2] = mux2_out;

endmodule