module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

    wire mux1_out, mux2_out;

    // Implementing mux_in[1] = c
    assign mux_in[1] = c;

    // Implementing mux_in[0] = 0
    assign mux_in[0] = 0;

    // Implementing mux_in[2] = c + d using a 2-to-1 mux
    // mux2_out selects between c and d
    // when d = 1, it means we want c + d = 1
    assign mux2_out = d ? 1 : c;

    // Implementing mux_in[3] = c using a 2-to-1 mux
    assign mux_in[3] = c;
    
    //Connecting mux_in[2] to mux2_out
    assign mux_in[2] = mux2_out;

endmodule