module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

    wire mux_0_out;
    wire mux_2_out;
    wire mux_3_out;

    // mux_in[0] = ~c + d.  c ? d : 1
    assign mux_0_out = c ? d : 1'b1;

    // mux_in[1] = 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c & d.  c ? d : 0
    assign mux_2_out = c ? d : 1'b0;

    // mux_in[3] = c + ~d.  c ? 1 : ~d
    assign mux_3_out = c ? 1'b1 : ~d;

    assign mux_in[0] = mux_0_out;
    assign mux_in[2] = mux_2_out;
    assign mux_in[3] = mux_3_out;

endmodule