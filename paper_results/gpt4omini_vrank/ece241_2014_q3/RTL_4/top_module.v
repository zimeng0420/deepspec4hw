module top_module (
    input c,
    input d,
    output [3:0] mux_in
);
    wire n1, n2, n3, n4;
    
    assign n1 = c & ~d;         // c=1, d=0 => 01 -> 1
    assign n2 = c & d;          // c=1, d=1 => 11 -> 1
    assign n3 = ~c & d;         // c=0, d=1 => 10 -> 0
    assign n4 = ~c & ~d;        // c=0, d=0 => 00 -> 0

    assign mux_in[0] = n4;      // mux_in[0] = cd = 00 => 0
    assign mux_in[1] = n1;      // mux_in[1] = cd = 01 => 1
    assign mux_in[2] = n2 | n3;  // mux_in[2] = cd = 11 => 1, cd = 10 => 0
    assign mux_in[3] = n2;      // mux_in[3] = cd = 10 => 1

endmodule