module top_module(
	input a, 
	input b,
	input c,
	output out
);

  assign out = ~a & ~b & c | ~a & b & ~c | ~a & b & c | a | b | c ;
//assign out = 1'b1;

endmodule