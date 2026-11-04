module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] = (~c & d) | (c & d) | (c & ~d)
    //            = (c & d) | (c & ~d) | (~c & d)
    // Use d for selection: 
    // If d=0, output ~c; if d=1, output 1 (since (c & d) covers both cases)
    assign mux_in[0] = d ? 1'b1 : ~c;

    // mux_in[1] = 0, always zero
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c & d
    assign mux_in[2] = c & d;

    // mux_in[3] = (~c & ~d) | (c & d) | (c & ~d)
    //            = (c & ~d) | (~c & ~d) | (c & d)
    // Use d for selection:
    // If d=0, output ~d; if d=1, output 1 (since (c & d) covers both cases)
    assign mux_in[3] = d ? 1'b1 : ~d;

endmodule