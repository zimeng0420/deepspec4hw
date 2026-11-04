module top_module(
    input x,
    input y,
    output z
);

    wire a1_out, a2_out, b1_out, b2_out;
    wire or_out, and_out;

    // Module A
    assign a1_out = (x ^ y) & x;
    assign a2_out = (x ^ y) & x;

    // Module B behavior based on the given waveform
    assign b1_out = (x == 0 && y == 0) ? 1 :
                    (x == 1 && y == 0) ? 0 :
                    (x == 0 && y == 1) ? 0 :
                    (x == 1 && y == 1) ? 1 : 1; // Default

    assign b2_out = (x == 0 && y == 0) ? 1 :
                    (x == 1 && y == 0) ? 0 :
                    (x == 0 && y == 1) ? 0 :
                    (x == 1 && y == 1) ? 1 : 0; // Default

    // OR and AND gates
    assign or_out = a1_out | b1_out;
    assign and_out = a2_out & b2_out;

    // Final XOR output
    assign z = or_out ^ and_out;

endmodule