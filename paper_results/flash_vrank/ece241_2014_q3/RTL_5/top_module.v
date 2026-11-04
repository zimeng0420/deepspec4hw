module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

    wire mux1_out;
    wire mux2_out;

    // mux_in[0]: ab = 00.  K-map column is 0 1 1 1.  This is equal to c OR d.
    assign mux_in[0] = c | d;

    // mux_in[1]: ab = 01. K-map column is 0 0 0 0. This is equal to 0.
    assign mux_in[1] = 1'b0;

    // mux_in[2]: ab = 11. K-map column is 0 0 1 1. This is equal to c AND d.
    assign mux_in[2] = c & d;

    // mux_in[3]: ab = 10. K-map column is 1 0 1 1.  Need a 2:1 mux. c=0 -> 1, c=1 -> d
    assign mux_in[3] = (~c) | (c & d);

endmodule