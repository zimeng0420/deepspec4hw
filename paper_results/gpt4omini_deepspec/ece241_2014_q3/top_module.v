module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

    assign mux_in[0] = 0; // For ab = 00
    assign mux_in[1] = c; // For ab = 01

    // Using a 2-to-1 MUX to generate mux_in[2]
    wire mux2_out;
    assign mux2_out = d ? 1'b1 : c; // mux_in[2] = c + d

    assign mux_in[2] = mux2_out; // For ab = 11

    assign mux_in[3] = c; // For ab = 10

endmodule