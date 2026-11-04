module top_module (
	input in1,
	input in2,
	input in3,
	output logic out
);
    logic xnor_out;

    // XNOR operation between in1 and in2
    assign xnor_out = ~(in1 ^ in2);
    
    // XOR operation with the XNOR result and in3
    assign out = xnor_out ^ in3;

endmodule