module top_module (
	input a, 
	input b, 
	input c, 
	input d,
	output q
);

	assign q = (c & (b | a)) | (c & d) | (b & ~a & ~d);

endmodule