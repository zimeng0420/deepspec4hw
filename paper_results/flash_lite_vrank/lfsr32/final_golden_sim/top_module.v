module top_module(
	input clk,
	input reset,
	output reg [31:0] q);

	always @(posedge clk) begin
		if (reset) begin
			q <= 32'h1;
		end else begin
			// Calculate the new value for the rightmost bit (bit 0)
			q[0] <= q[31] ^ q[21] ^ q[1] ^ q[0];

			// Shift the other bits to the right
			for (int i = 1; i < 32; i++) begin
				q[i] <= q[i-1];
			end
		end
	end

endmodule