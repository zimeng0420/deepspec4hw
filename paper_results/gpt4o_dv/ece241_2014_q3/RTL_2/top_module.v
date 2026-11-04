module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

    // Implement each mux_in value using minimal 2-to-1 multiplexers
    assign mux_in[0] = (~c & d) | (c & d) | (c & ~d);
    assign mux_in[1] = 0;
    assign mux_in[2] = c & d;
    assign mux_in[3] = (~c & ~d) | (c & d) | (c & ~d);

endmodule