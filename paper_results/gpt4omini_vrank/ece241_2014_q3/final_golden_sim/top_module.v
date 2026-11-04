module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

    wire mux0, mux1, mux2, mux3;

    assign mux0 = 0; // Corresponds to ab = 00
    assign mux1 = c; // Corresponds to ab = 01
    assign mux2 = (c) ? d : 0; // Corresponds to ab = 11
    assign mux3 = (c) ? 1 : d; // Corresponds to ab = 10

    assign mux_in = {mux3, mux2, mux1, mux0};

endmodule