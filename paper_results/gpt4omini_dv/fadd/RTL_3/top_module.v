module top_module (
	input a,
	input b,
	input cin,
	output cout,
	output sum
);

wire S1, C1;

assign S1 = a ^ b;           // First half adder sum
assign C1 = a & b;           // First half adder carry

assign sum = S1 ^ cin;       // Final sum
assign cout = C1 | (cin & S1); // Final carry-out

endmodule