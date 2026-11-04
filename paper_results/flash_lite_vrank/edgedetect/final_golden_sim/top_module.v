module top_module(
	input clk,
	input [7:0] in,
	output reg [7:0] pedge);

	reg [7:0] in_reg;
	reg [7:0] pedge_reg;

	always @(posedge clk) begin
		in_reg <= in;
		pedge_reg <= 8'b0; // Reset the pulse register

		for (integer i = 0; i < 8; i = i + 1) begin
			if (in_reg[i] == 1'b0 && in[i] == 1'b1) begin
				pedge_reg[i] <= 1'b1; // Set the pulse bit if 0->1 transition
			end
		end
		pedge <= pedge_reg;
	end
endmodule