module top_module (
	input a,
	input b,
	input cin,
	output cout,
	output sum
);

    wire xor_ab, and_ab, and_bc, and_ca;

    assign xor_ab = a ^ b;
    assign sum = xor_ab ^ cin;
    assign and_ab = a & b;
    assign and_bc = b & cin;
    assign and_ca = cin & a;
    assign cout = and_ab | and_bc | and_ca;

endmodule