module top_module(
	input clk,
	input [7:0] in,
	output reg [7:0] anyedge
);

	reg [7:0] in_reg;
	reg [7:0] edge_detect;

	always @(posedge clk) begin
		in_reg <= in;
		edge_detect <= in ^ in_reg; // Detect edges (0->1 or 1->0)
	end

	always @(posedge clk) begin
		anyedge <= edge_detect; // Set output one cycle after edge detection
	end

endmodule