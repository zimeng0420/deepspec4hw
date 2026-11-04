module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

    wire mux1_out;
    wire mux2_out;

    // Implement mux_in[0]
    assign mux_in[0] = ~c & ~d;

    // Implement mux_in[1]
    assign mux_in[1] = 1'b0;

    // Implement mux_in[2]
    assign mux1_out = c | d;
    assign mux_in[2] = mux1_out;

    // Implement mux_in[3]
    assign mux2_out = ~c | ~d;
    assign mux_in[3] = mux2_out;

endmodule