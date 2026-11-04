module top_module (
	input a, 
	input b,
	input c,
	input d,
	output out
);

    assign out = (~a & ~b & ~d) | (~b & ~c) | (a & b & d) | (a & ~c & ~d) | (~a & c & d) | (b & c & ~d);

endmodule