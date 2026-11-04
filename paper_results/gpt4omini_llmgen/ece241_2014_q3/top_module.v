module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

// Assigning values to mux_in based on K-map
assign mux_in[0] = 0; // ab = 00
assign mux_in[1] = c; // ab = 01
assign mux_in[2] = c & d; // ab = 10 (c * d)
assign mux_in[3] = c | d; // ab = 11 (c + d)

endmodule