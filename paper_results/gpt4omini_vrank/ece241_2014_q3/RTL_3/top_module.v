module top_module (
    input c,
    input d,
    output [3:0] mux_in
);
    wire n1, n2, n3;

    // Implementing the K-map logic 
    assign mux_in[0] = 0;                   // ab = 00
    assign mux_in[1] = c;                   // ab = 01
    assign mux_in[2] = (c & d);             // ab = 11
    assign mux_in[3] = (c & ~d) | (d);      // ab = 10
endmodule