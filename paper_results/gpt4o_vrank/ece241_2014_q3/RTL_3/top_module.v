module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

    // Implementing the logic from the K-map:
    // cd   00 01 11 10
    //  00 | 0 | 0 | 0 | 1 |
    //  01 | 1 | 0 | 0 | 0 |
    //  11 | 1 | 0 | 1 | 1 |
    //  10 | 1 | 0 | 0 | 1 |

    assign mux_in[0] = (c & d) | (~c & d);
    assign mux_in[1] = 0;
    assign mux_in[2] = (c & d) | (c & ~d);
    assign mux_in[3] = (~c & d) | (c & d) | (~c & ~d);

endmodule