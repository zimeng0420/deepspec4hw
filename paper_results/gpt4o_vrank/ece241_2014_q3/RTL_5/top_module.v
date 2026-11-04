module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

// Using a truth table derived from the given K-map for each mux_in
assign mux_in[0] = d;        // ab = 00, value from K-map is d
assign mux_in[1] = 0;        // ab = 01, value from K-map is 0
assign mux_in[2] = c | d;    // ab = 11, value from K-map is c + d (OR operation)
assign mux_in[3] = 1;        // ab = 10, value from K-map is 1

endmodule