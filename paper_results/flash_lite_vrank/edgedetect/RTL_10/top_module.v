module top_module(
	input clk,
	input [7:0] in,
	output reg [7:0] pedge
);

	reg [7:0] in_prev;
	reg [7:0] pedge_delayed;

	always @(posedge clk) begin
		in_prev <= in;
		pedge_delayed <= 0;
		for (int i = 0; i < 8; i = i + 1) begin
			if (~in_prev[i] & in[i]) begin
				pedge_delayed[i] <= 1;
			end
		end
		pedge <= pedge_delayed;
	end

endmodule