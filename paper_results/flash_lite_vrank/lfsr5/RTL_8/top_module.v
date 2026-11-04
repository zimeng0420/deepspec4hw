module top_module(
	input clk,
	input reset,
	output reg [4:0] q);

	always @(posedge clk) begin
		if (reset) begin
			q <= 5'b00001; // Initialize to 1
		end else begin
			q <= {q[0] ^ q[2], q[4], q[3], q[2], q[1]}; // Galois LFSR update
		end
	end
endmodule