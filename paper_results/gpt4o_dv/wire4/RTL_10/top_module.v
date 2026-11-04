module top_module (
	input a,
	input b,
	input c,
	output w,
	output x,
	output y,
	output z
);

    assign w = a; // Connect input a to output w
    assign x = b; // Connect input b to output x
    assign y = b; // Connect input b to output y
    assign z = c; // Connect input c to output z

endmodule