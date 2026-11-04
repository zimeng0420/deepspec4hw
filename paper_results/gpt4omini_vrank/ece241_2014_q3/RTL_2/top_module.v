module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

    wire ncd, ncb, nbc;
    assign ncd = c & ~d; // c and not d
    assign ncb = ~c & d; // not c and d
    assign nbc = ~c & ~d; // not c and not d

    assign mux_in[0] = 0;   // ab = 00
    assign mux_in[1] = ncd;  // ab = 01
    assign mux_in[2] = nbc;  // ab = 11
    assign mux_in[3] = ncd | (c & d); // ab = 10 -> gives 1 when c=1, d=1 OR c=0, d=1

endmodule