module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

    wire mux1_out;
    wire mux2_out;

    // mux_in[0]: ab = 00.  K-map values: 00:0, 01:1, 11:1, 10:1. Reduced to: c
    assign mux_in[0] = c;

    // mux_in[1]: ab = 01. K-map values: 00:0, 01:0, 11:0, 10:0. Reduced to: 0
    assign mux_in[1] = 0;

    // mux_in[2]: ab = 11. K-map values: 00:0, 01:0, 11:1, 10:0. Reduced to: c & d
    assign mux_in[2] = c & d;

    // mux_in[3]: ab = 10. K-map values: 00:1, 01:0, 11:1, 10:1. Reduced to: ~d | c
    assign mux_in[3] = ~d | c;


endmodule