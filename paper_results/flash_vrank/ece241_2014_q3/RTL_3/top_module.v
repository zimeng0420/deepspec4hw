module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

    wire mux1_out;
    wire mux2_out;

    // mux_in[0]: ab = 00.  Output = cd' + c'd' + c'd = c'd' + c'
    assign mux_in[0] = ~c & (~d);  // Equivalent to ~c & ~d

    // mux_in[1]: ab = 01.  Output = 0
    assign mux_in[1] = 1'b0;

    // mux_in[2]: ab = 11.  Output = cd' + cd + c'd = c + cd' + c'd
    // Optimized: c + cd' + c'd = c + d
    assign mux_in[2] = c | d;

    // mux_in[3]: ab = 10.  Output = cd' + c'd' + cd = d' + cd
    //Optimized to d' to remove need for extra gates
    assign mux_in[3] = ~d;

endmodule