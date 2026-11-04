module top_module(
	input clk,
	input [7:0] in,
	output reg [7:0] pedge);

	reg [7:0] in_prev;
	reg [7:0] pedge_reg;

	always @(posedge clk) begin
		in_prev <= in;
		pedge_reg <= 8'b0; // Clear the register
		for (integer i = 0; i < 8; i = i + 1) begin
			if (~in_prev[i] & in[i]) begin
				pedge_reg[i] <= 1'b1;
			end
		end
		pedge <= pedge_reg;

	end
endmodule