module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

    wire mux_in0;
    wire mux_in3;

    // mux_in[0] = ~c | d
    assign mux_in0 = ~c | d;

    // mux_in[1] = 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c & d
    assign mux_in[2] = c & d;

    // mux_in[3] = (~c & ~d) | c
    assign mux_in3 = (~c & ~d) | c;

    assign mux_in[0] = mux_in0;
    assign mux_in[3] = mux_in3;

endmodule