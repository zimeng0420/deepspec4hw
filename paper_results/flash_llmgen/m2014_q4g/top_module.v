module top_module (
    input in1,
    input in2,
    input in3,
    output logic out
);

    logic xnor_out; // Intermediate signal for XNOR output

    // XNOR gate
    assign xnor_out = ~(in1 ^ in2);  // Equivalent to in1 ~^ in2 or in1 == in2

    // XOR gate
    assign out = xnor_out ^ in3;

endmodule