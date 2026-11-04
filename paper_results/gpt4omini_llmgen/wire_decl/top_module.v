module top_module (
	input a,
	input b,
	input c,
	input d,
	output out,
	output out_n );
	
    // Intermediate wires to connect the outputs of the AND gates to the OR gate
	wire and_out1;  // Connects inputs a and b
	wire and_out2;  // Connects inputs c and d

    // First AND gate: and_out1 = a AND b
	and U1 (and_out1, a, b);

    // Second AND gate: and_out2 = c AND d
	and U2 (and_out2, c, d);

    // OR gate: out = and_out1 OR and_out2
	or U3 (out, and_out1, and_out2);

    // NOT gate: out_n = NOT(out)
	not U4 (out_n, out);
    
endmodule