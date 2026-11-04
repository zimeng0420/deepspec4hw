module top_module(
	input clk,
	input [7:0] in,
	output reg [7:0] anyedge
);

	reg [7:0] in_prev;
	reg [7:0] edge_detect;

	always @(posedge clk) begin
		in_prev <= in;
		edge_detect <= in ^ in_prev; // Detect changes (XOR)
		anyedge <= edge_detect; //Set anyedge in the same cycle when changes happen
	end

endmodule