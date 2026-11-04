module top_module(
	input clk,
	input [7:0] in,
	output reg [7:0] pedge
);

	reg [7:0] in_reg;
	reg [7:0] pedge_temp;

	always @(posedge clk) begin
		in_reg <= in;
		pedge_temp <= 8'b0;
		for (int i = 0; i < 8; i = i + 1) begin
			if (~in_reg[i] & in[i]) begin
				pedge_temp[i] <= 1'b1;
			end
		end
		pedge <= pedge_temp;
	end

endmodule