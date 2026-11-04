module top_module (
    input in1,
    input in2,
    input in3,
    output logic out
);

    // Intermediate signal for XNOR output
    logic xnor_out;
    
    // XNOR gate for in1 and in2
    assign xnor_out = ~(in1 ^ in2);
    
    // XOR gate for xnor_out and in3
    assign out = xnor_out ^ in3;

endmodule