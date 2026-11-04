module top_module(
	input clk,
	input [7:0] d,
	input reset,
	output reg [7:0] q
);

	integer i;

	always @(posedge clk) begin
		if (reset) begin
			for (i = 0; i < 8; i = i + 1) begin
				q[i] <= 1'b0;
			end
		end else begin
			for (i = 0; i < 8; i = i + 1) begin
				q[i] <= d[i];
			end
		end
	end
endmodule