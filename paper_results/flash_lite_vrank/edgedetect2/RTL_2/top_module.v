module top_module(
	input clk,
	input [7:0] in,
	output reg [7:0] anyedge
);

	reg [7:0] in_reg;
	reg [7:0] edge_detect;

	always @(posedge clk) begin
		in_reg <= in;
		edge_detect <= in ^ in_reg;
		anyedge <= edge_detect;
	end

endmodule