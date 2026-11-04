module top_module (
    input c,
    input d,
    output [3:0] mux_in
);
    assign mux_in[0] = d;          // For ab = 00, output the value corresponding to cd = 00 -> 0 (hence, d=1 results in 1)
    assign mux_in[1] = ~c & ~d;    // For ab = 01, corresponding to cd = 01 -> 1
    assign mux_in[2] = c;          // For ab = 11, corresponding to cd = 11 -> 1
    assign mux_in[3] = d;          // For ab = 10, corresponding to cd = 10 -> 1
endmodule