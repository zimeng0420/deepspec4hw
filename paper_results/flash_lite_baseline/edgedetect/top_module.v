module top_module(
	input clk,
	input [7:0] in,
	output reg [7:0] pedge
);

	reg [7:0] in_reg;
	reg [7:0] pedge_delayed;

	always @(posedge clk) begin
		in_reg <= in;
		pedge_delayed <= 8'b0;
		for (int i = 0; i < 8; i++) begin
			if (in_reg[i] == 1'b0 && in[i] == 1'b1) begin
				pedge_delayed[i] <= 1'b1;
			end
		end
	end

	always @(posedge clk) begin
		pedge <= pedge_delayed;
	end

endmodule