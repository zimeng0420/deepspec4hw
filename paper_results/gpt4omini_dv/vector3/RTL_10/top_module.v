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

assign w = {a, b, c, d}; // First 20 bits from the first four inputs
assign x = {e};          // Next 5 bits from input e
assign y = {f};          // Next 5 bits from input f
assign z = 8'b00000011;  // Last two bits set to 1

endmodule