module top_module (
    input a,
    input b,
    input c,
    output w,
	output x,
	output y,
	output z
);

    assign w = a; // Connection a -> w
    assign x = b; // Connection b -> x
    assign y = b; // Connection b -> y
    assign z = c; // Connection c -> z

endmodule