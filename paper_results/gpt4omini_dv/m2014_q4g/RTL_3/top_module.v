module top_module (
    input in1,
    input in2,
    input in3,
    output logic out
);
    logic xnor_output;

    // XNOR operation
    assign xnor_output = (in1 ~^ in2);
    
    // XOR operation with in3
    assign out = xnor_output ^ in3;

endmodule