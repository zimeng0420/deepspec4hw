module top_module(
	input clk,
	input [7:0] in,
	output reg [7:0] pedge
);

	reg [7:0] prev_in;
	reg [7:0] delayed_pedge;

	always @(posedge clk) begin
		prev_in <= in;
		delayed_pedge <= 0;

		for (int i = 0; i < 8; i++) begin
			if (prev_in[i] == 0 && in[i] == 1) begin
				delayed_pedge[i] <= 1;
			end
		end
	end

	always @(posedge clk) begin
		pedge <= delayed_pedge;
	end
endmodule