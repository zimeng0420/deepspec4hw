module top_module(
	input clk,
	input [7:0] in,
	output reg [7:0] anyedge
);

	reg [7:0] in_reg;
	reg [7:0] edge_detected;

	always @(posedge clk) begin
		in_reg <= in;
		edge_detected <= in ^ in_reg;
		anyedge <= (edge_detected & ~{8{1'b0}}) ; // Ensure the output is reset immediately after detecting an edge
	end

	always @(posedge clk) begin
		// Shift the edge_detected bits to the output in the next cycle
        anyedge <= (edge_detected & ~in_reg);
	end

endmodule