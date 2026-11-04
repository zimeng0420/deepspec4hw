module top_module (
	input [4:0] a,
	input [4:0] b,
	input [4:0] c,
	input [4:0] d,
	input [4:0] e,
	input [4:0] f,
	output [7:0] w,
	output [7:0] x,
	output [7:0] y,
	output [7:0] z
);

	assign w = {a, b, c, d}; // 20 bits from inputs a, b, c, d
	assign x = {e};         // 5 bits from input e
	assign y = {f};         // 5 bits from input f
	assign z = 8'b00000011; // 2 bits set to 1 at LSB

endmodule