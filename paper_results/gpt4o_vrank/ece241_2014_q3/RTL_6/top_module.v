module top_module (
    input c,
    input d,
    output [3:0] mux_in
);
    // Inputs for the 4-to-1 multiplexer
    // Using bit vectors for output
    // mux_in[0] = ~c & d
    // mux_in[1] = 0 
    // mux_in[2] = c | d
    // mux_in[3] = ~d

    assign mux_in[0] = (~c & d);
    assign mux_in[1] = 0;
    assign mux_in[2] = (c | d);
    assign mux_in[3] = ~d;

endmodule