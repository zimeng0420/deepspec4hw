module top_module(
	input clk,
	input [7:0] in,
	output reg [7:0] pedge);
	
	reg [7:0] prev_in;

	always @(posedge clk) begin
		pedge <= in & ~prev_in; // Detect positive edges
		prev_in <= in; // Store current input for the next cycle
	end
endmodule