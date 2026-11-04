module top_module(
	input clk,
	input [7:0] in,
	output reg [7:0] anyedge
);

	reg [7:0] prev_in;
	reg [7:0] edge_detect;

	always @(posedge clk) begin
		edge_detect <= 8'b0;
		for (integer i = 0; i < 8; i = i + 1) begin
			if (in[i] != prev_in[i]) begin
				edge_detect[i] <= 1'b1;
			end
		end
		prev_in <= in;
		anyedge <= edge_detect;

	end

endmodule