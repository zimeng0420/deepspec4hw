module top_module(
	input clk,
	input load,
	input [511:0] data,
	output reg [511:0] q);

	always @(posedge clk) begin
		if (load) begin
			q <= data;
		end else begin
			integer i;
			reg [511:0] next_q;
			// Calculate the next state for each cell
			next_q[0] = q[1]; // q[-1] assumed to be 0, so q[0] = q[-1] ^ q[1] = 0 ^ q[1] = q[1]
			for (i = 1; i < 511; i = i + 1) begin
				next_q[i] = q[i-1] ^ q[i+1];
			end
			next_q[511] = q[510]; // q[512] assumed to be 0, so q[511] = q[510] ^ q[512] = q[510] ^ 0 = q[510]
			q <= next_q;
		end
	end
endmodule