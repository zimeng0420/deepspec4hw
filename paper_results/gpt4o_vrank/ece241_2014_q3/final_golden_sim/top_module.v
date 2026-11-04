module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

    // Implement the K-map as given

    // mux_in[0] corresponds to ab = 00
    // (cd = 00,01,11,10: mux_in[0] = 1 if cd = 10,01,11)
    assign mux_in[0] = (~c & d) | (c & d);

    // mux_in[1] corresponds to ab = 01
    // (cd = 00,01,11,10: mux_in[1] = 1 if cd = none)
    assign mux_in[1] = 0;  // No condition satisfies 

    // mux_in[2] corresponds to ab = 11
    // (cd = 00,01,11,10: mux_in[2] = 1 if cd = 11)
    assign mux_in[2] = c & d;

    // mux_in[3] corresponds to ab = 10
    // (cd = 00,01,11,10: mux_in[3] = 1 if cd = 10,11)
    assign mux_in[3] = c | d;

endmodule