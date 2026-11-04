module top_module(
	input clk,
	input [7:0] in,
	output reg [7:0] anyedge
);

	reg [7:0] prev_in;
	reg [7:0] edge_detected;

	always @(posedge clk) begin
		edge_detected <= 8'b0;
		for (int i = 0; i < 8; i++) begin
			if (in[i] != prev_in[i]) begin
				edge_detected[i] <= 1'b1;
			end
		end
		prev_in <= in;
		anyedge <= edge_detected;
	end

endmodule