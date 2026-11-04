module top_module (
	input [7:0] a,
	input [7:0] b,
	input [7:0] c,
	input [7:0] d,
	output reg [7:0] min
);

	always @(*) begin
		// First level of pairwise comparisons
		reg [7:0] min1;
		reg [7:0] min2;

		min1 = (a < b) ? a : b; // Find minimum of a and b
		min2 = (c < d) ? c : d; // Find minimum of c and d

		// Final comparison for overall minimum
		min = (min1 < min2) ? min1 : min2;
	end

endmodule