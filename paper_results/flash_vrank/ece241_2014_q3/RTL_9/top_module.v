module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

    wire w1, w2;

    assign w1 = c | d;
    assign w2 = c & d;

    assign mux_in[0] = 0;
    assign mux_in[1] = 0;
    assign mux_in[2] = w2;
    assign mux_in[3] = w1;

endmodule