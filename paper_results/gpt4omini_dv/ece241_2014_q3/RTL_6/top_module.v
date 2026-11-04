module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

    wire mux1_out; // Output of 2-to-1 multiplexer for mux_in[1]
    wire mux2_out; // Output of 2-to-1 multiplexer for mux_in[2]

    // mux_in[0] = 0
    assign mux_in[0] = 1'b0;

    // mux_in[1] = c
    assign mux_in[1] = c;

    // mux_in[2] = c + d implemented using a 2-to-1 mux
    // Select between c and d based on d being 1
    assign mux2_out = d ? 1'b1 : c;
    assign mux_in[2] = mux2_out;

    // mux_in[3] = c
    assign mux_in[3] = c;

endmodule