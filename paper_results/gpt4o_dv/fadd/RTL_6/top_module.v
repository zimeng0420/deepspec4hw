module top_module (
	input a,
	input b,
	input cin,
	output cout,
	output sum
);

    // Intermediate signal for (a XOR b)
    wire axorb;
    assign axorb = a ^ b;
	
    // Sum calculation
    assign sum = axorb ^ cin;
	
    // Carry-out calculation
    assign cout = (a & b) | (cin & axorb);

endmodule