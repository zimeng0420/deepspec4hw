module top_module (
	input a, 
	input b,
	input c,
	input d,
	output out
);
	assign out = (a & ~b & ~c & ~d) | (a & ~b & d) | (a & c & ~d) | (~a & ~b & c) |
                 (b & c) | (b & ~a & d) | (b & a & ~c) | (~b & ~a & d);
endmodule