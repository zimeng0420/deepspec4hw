module top_module (
    input c,
    input d,
    input a,
    input b,
    output [3:0] mux_in
);
    
    wire w1, w2, w3, w4;

    // Intermediate MUX using 2-to-1 multiplexers
    assign w1 = (c & ~d) ? 1 : 0; // 01 -> 1
    assign w2 = (c & d) ? 1 : 0;   // 11 -> 1
    assign w3 = (c & ~d) ? 1 : 0;  // 10 -> 1
    assign w4 = (d & ~c) ? 1 : 0;  // 00 -> 0

    assign mux_in[0] = 0; // ab = 00
    assign mux_in[1] = w1; // ab = 01
    assign mux_in[2] = w2; // ab = 11
    assign mux_in[3] = w3; // ab = 10

endmodule