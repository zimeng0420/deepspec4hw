module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

    wire n1, n2, n3, n4;

    // Connections for 2-to-1 multiplexers
    assign n1 = c & ~d;   // cd=01 => 1
    assign n2 = ~c & ~d;  // cd=00 => 0
    assign n3 = ~c & d;   // cd=10 => 0
    assign n4 = c & d;     // cd=11 => 1

    // Mux input assignments
    assign mux_in[0] = n2; // ab = 00 => 0
    assign mux_in[1] = n1; // ab = 01 => 1
    assign mux_in[2] = n4; // ab = 11 => 1
    assign mux_in[3] = n3; // ab = 10 => 0

endmodule