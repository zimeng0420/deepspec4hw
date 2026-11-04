module top_module(
	input clk,
	input reset,
	output reg [31:0] q);

	always @(posedge clk) begin
		if (reset) begin
			q <= 32'h1;
		end else begin
			// Calculate the XOR of the tap positions
			bit [31:0] feedback;
			feedback = q[0] ^ q[21] ^ q[30] ^ q[31]; // Use q[31] as the MSB

			// Shift and update
			q <= {feedback, q[31:1]}; // MSB first, so feedback goes to q[31]
		end
	end
endmodule