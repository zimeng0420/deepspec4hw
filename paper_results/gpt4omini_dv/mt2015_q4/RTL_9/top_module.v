module top_module(
    input x,
    input y,
    output z
);

    wire z_A1, z_A2;
    wire z_B1, z_B2;
    wire z_OR, z_AND;

    // Module A implementation
    assign z_A1 = (x ^ y) & x;
    assign z_A2 = (x ^ y) & x;

    // Module B behavior based on the waveform
    assign z_B1 = (x == 0 && y == 0) ? 1 :
                  (x == 1 && y == 0) ? 0 :
                  (x == 0 && y == 1) ? 0 :
                  (x == 1 && y == 1) ? 1 : 0;

    assign z_B2 = (x == 0 && y == 0) ? 1 :
                  (x == 1 && y == 0) ? 0 :
                  (x == 0 && y == 1) ? 0 :
                  (x == 1 && y == 1) ? 1 : 0;

    // OR and AND gates
    assign z_OR = z_A1 | z_B1;
    assign z_AND = z_A2 & z_B2;

    // Final output
    assign z = z_OR ^ z_AND;

endmodule