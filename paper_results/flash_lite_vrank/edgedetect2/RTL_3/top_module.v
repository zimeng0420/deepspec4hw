module top_module(
	input clk,
	input [7:0] in,
	output reg [7:0] anyedge);

	reg [7:0] in_reg;
	reg [7:0] edge_detected;

	always @(posedge clk) begin
		in_reg <= in;
		edge_detected <= in_reg ^ in; // Detect any edge (0->1 or 1->0)
		anyedge <= edge_detected; // Set anyedge the cycle after a transition
	end

endmodule