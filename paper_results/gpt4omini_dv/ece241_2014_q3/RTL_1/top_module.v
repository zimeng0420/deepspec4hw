module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

    wire a; // Placeholder for a
    wire b; // Placeholder for b

    // mux_in[1] = c
    assign mux_in[1] = c;

    // mux_in[3] = c
    assign mux_in[3] = c;

    // mux_in[2] = c + d (Using 2-to-1 mux)
    wire mux2_out1, mux2_out2;
    assign mux2_out1 = d; // signal d goes to one input of the 2-to-1 mux
    assign mux2_out2 = 1; // connect to logic high for the other input
    assign mux_in[2] = (c) ? mux2_out1 : mux2_out2; // Select d or 1 based on c

    // mux_in[0] = 0
    assign mux_in[0] = 0;

endmodule