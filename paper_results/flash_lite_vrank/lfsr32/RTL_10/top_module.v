module top_module(
	input clk,
	input reset,
	output reg [31:0] q);

	always @(posedge clk) begin
		if (reset) begin
			q <= 32'h1;
		end else begin
			// Calculate the new value of q[0] (LSB)
			reg feedback = q[31] ^ q[21] ^ q[1] ^ q[0];

			// Shift the register and apply feedback
			q <= {feedback, q[31:1]};
		end
	end
endmodule