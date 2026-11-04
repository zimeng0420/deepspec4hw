module top_module (
    input c,
    input d,
    output [3:0] mux_in
);
    wire w1, w2, w3, w4;

    // Implementing the conditions for each mux_in based on the K-map
    assign mux_in[0] = 0;  // ab = 00
    assign mux_in[1] = c;  // ab = 01 (1 for cd = 01)
    assign mux_in[2] = w1; // ab = 11
    assign mux_in[3] = w2; // ab = 10

    // 2-to-1 Mux logic for mux_in[2]
    assign w1 = (c) ? 1 : 0; // Corresponds to cd = 11 (1 for d = 1)

    // 2-to-1 Mux logic for mux_in[3]
    assign w2 = (c) ? 1 : 0; // Corresponds to cd = 10 (1 for d = 0)

endmodule