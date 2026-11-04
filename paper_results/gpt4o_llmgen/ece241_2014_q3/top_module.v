module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

    // Generate mux_in[0] for ab=00: d'c' + dc
    assign mux_in[0] = (~d & ~c) | (d & c);
    
    // mux_in[1] for ab=01 is constant zero
    assign mux_in[1] = 0;

    // Generate mux_in[2] for ab=11: d
    assign mux_in[2] = d;

    // Generate mux_in[3] for ab=10: d' + c
    assign mux_in[3] = (~d) | c;

endmodule