module top_module(
	input clk,
	input load,
	input [511:0] data,
	output reg [511:0] q);

	reg [511:0] next_q;

	always @(posedge clk) begin
		if (load) begin
			q <= data;
		end else begin
			for (int i = 0; i < 512; i = i + 1) begin
				// Handle boundary conditions: q[-1] and q[512] are always 0
				if (i == 0) begin
					next_q[i] <= q[i+1]; // Left neighbor is 0
				end else if (i == 511) begin
					next_q[i] <= q[i-1]; // Right neighbor is 0
				end else begin
					next_q[i] <= q[i-1] ^ q[i+1];
				end
			end
			q <= next_q;
		end
	end
endmodule