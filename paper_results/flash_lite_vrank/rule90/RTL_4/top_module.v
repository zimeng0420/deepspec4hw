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
			// Calculate next state based on Rule 90
			for (integer i = 0; i < 512; i = i + 1) begin
				// Handle boundary conditions: q[-1] = 0, q[512] = 0
				wire left_neighbor;
				wire right_neighbor;

				assign left_neighbor = (i == 0) ? 1'b0 : q[i - 1];
				assign right_neighbor = (i == 511) ? 1'b0 : q[i + 1];

				next_q[i] <= left_neighbor ^ right_neighbor;

			end
			q <= next_q;
		end
	end

endmodule