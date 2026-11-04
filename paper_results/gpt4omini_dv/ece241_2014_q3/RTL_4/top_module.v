module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

    wire mux1_out;
    wire mux2_out;

    // 2-to-1 MUX for mux_in[1] (c)
    assign mux_in[1] = c;

    // 2-to-1 MUX for mux_in[2] (c + d)
    assign mux1_out = c | d; // mux1_out = c + d

    // 2-to-1 MUX for mux_in[3] (c)
    assign mux_in[3] = c;

    // Assign values to mux_in[0] = 0
    assign mux_in[0] = 0;

    // Assign mux_in[2] based on mux1_out
    assign mux_in[2] = mux1_out;

endmodule