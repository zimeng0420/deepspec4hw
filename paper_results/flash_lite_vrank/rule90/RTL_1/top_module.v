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
			// Rule 90 calculation
			next_q[0] = q[1];  // Boundary condition q[-1] = 0, so XOR with q[1]
			for (int i = 1; i < 511; i++) begin
				next_q[i] = q[i-1] ^ q[i+1];
			end
			next_q[511] = q[510]; // Boundary condition q[512] = 0, so XOR with q[510]
			q <= next_q;
		end
	end
endmodule