module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

    // Generate mux_in[0] for ab = 00
    assign mux_in[0] = ~c & d | c & ~d;

    // Generate mux_in[1] for ab = 01
    assign mux_in[1] = 0;

    // Generate mux_in[2] for ab = 11
    assign mux_in[2] = c;

    // Generate mux_in[3] for ab = 10
    assign mux_in[3] = 1;

endmodule