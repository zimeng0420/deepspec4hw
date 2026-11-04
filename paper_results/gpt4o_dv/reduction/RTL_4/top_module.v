module top_module (
	input [7:0] in,
	output parity
);

    // Using reduction XOR to compute the even parity bit
    assign parity = ^in;

endmodule