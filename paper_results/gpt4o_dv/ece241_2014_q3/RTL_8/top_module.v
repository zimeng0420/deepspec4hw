module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

    // Implementing mux_in[0]: mux_in[0] = (~c & d) | (c & d) | (c & ~d)
    assign mux_in[0] = (c & d) | (~c & d) | (c & ~d); 

    // Implementing mux_in[1]: mux_in[1] = 0
    assign mux_in[1] = 0;

    // Implementing mux_in[2]: mux_in[2] = c & d
    assign mux_in[2] = c & d;

    // Implementing mux_in[3]: mux_in[3] = (~c & ~d) | (c & d) | (c & ~d)
    assign mux_in[3] = (c & d) | (~c & ~d) | (c & ~d); 

endmodule