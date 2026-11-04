module top_module (
	input [7:0] a,
	input [7:0] b,
	input [7:0] c,
	input [7:0] d,
	output reg [7:0] min
);

	always @(*) begin
		min = a; // Start with 'a' as the minimum

		if (b < min)
			min = b; // If 'b' is smaller, update min to 'b'
		if (c < min)
			min = c; // If 'c' is smaller, update min to 'c'
		if (d < min)
			min = d; // If 'd' is smaller, update min to 'd'
	end

endmodule