module top_module (
	input a,
	input b,
	input c,
	input d,
	output out,
	output out_n 
);

	wire and1_out; // Intermediate wire for the first AND gate
	wire and2_out; // Intermediate wire for the second AND gate

	and and1 (and1_out, a, b); // First AND gate
	and and2 (and2_out, c, d); // Second AND gate
	or  or1 (out, and1_out, and2_out); // OR gate combining the outputs of the AND gates
	not not1 (out_n, out); // Inverter for the output

endmodule