module top_module (
	input [99:0] in,
	output [98:0] out_both,
	output [99:1] out_any,
	output [99:0] out_different
);

	// out_both
	genvar i;
	generate
		for (i = 0; i < 99; i = i + 1) begin: both_gen
			assign out_both[i] = in[i] & in[i+1];
		end
	endgenerate

	// out_any
	genvar j;
	generate
		for (j = 1; j < 100; j = j + 1) begin: any_gen
			assign out_any[j] = in[j] | in[j-1];
		end
	endgenerate

	// out_different
    assign out_different[99] = in[99] ^ in[0];
    genvar k;
    generate
        for (k = 0; k < 99; k = k + 1) begin: diff_gen
            assign out_different[k] = in[k] ^ in[k+1];
        end
    endgenerate


endmodule