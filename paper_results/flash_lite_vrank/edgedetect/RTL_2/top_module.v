module top_module(
	input clk,
	input [7:0] in,
	output reg [7:0] pedge
);

	reg [7:0] prev_in;
	reg [7:0] detect;

	always @(posedge clk) begin
		detect <= (in & ~prev_in);
		prev_in <= in;
		pedge <= detect;

	end

endmodule