module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

    // Define intermediate signals for 2-to-1 multiplexers
    wire d_and_c;
    wire not_d_and_c;
    wire d_or_not_c;
    wire not_d;

    // Logic expressions
    assign d_and_c = d & c;           // Expression for the (11, 10) K-map entries
    assign not_d_and_c = ~d & c;      // Expression for the (01, 11) K-map entries
    assign d_or_not_c = d | ~c;       // Expression for the (10, 11) K-map entries
    assign not_d = ~d;                // Expression for the (00, 01, 10) K-map entries

    // Mapping to 4-to-1 multiplexer inputs
    assign mux_in[0] = d_and_c;       // For ab = 00
    assign mux_in[1] = not_d;         // For ab = 01
    assign mux_in[2] = d_or_not_c;    // For ab = 11
    assign mux_in[3] = not_d_and_c;   // For ab = 10

endmodule