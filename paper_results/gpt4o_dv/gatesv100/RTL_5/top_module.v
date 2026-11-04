module top_module (
	input [99:0] in,
	output [98:0] out_both,
	output [99:1] out_any,
	output [99:0] out_different
);

	// out_both: each bit indicates whether both the current bit and its neighbor to the left are '1'
	assign out_both = in[98:0] & in[99:1];
	
	// out_any: each bit indicates whether any of the current bit and its neighbor to the right are '1'
	assign out_any = in[99:1] | in[98:0];
	
	// out_different: each bit indicates whether the current bit is different from its neighbor to the left
	assign out_different = in ^ {in[0], in[99:1]};

endmodule