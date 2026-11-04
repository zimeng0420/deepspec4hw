module top_module(
	input clk,
	input [7:0] in,
	output reg [7:0] pedge);

	reg [7:0] prev_in; // Register to store the previous state of 'in'

	always @(posedge clk) begin
		// Detect positive edge for each bit and set the corresponding pedge bit
		pedge <= (~prev_in) & in;
		// Update the previous input state
		prev_in <= in;
	end
endmodule