module top_module(
	input a, 
	input b,
	input c,
	output out
);

    assign out = (~b & c) | (b & ~c) | (c & ~a) | (~c & a);

endmodule