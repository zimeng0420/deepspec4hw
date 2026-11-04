module top_module(
	input clk,
	input reset,
	output reg [31:0] q);

	always @(posedge clk) begin
		if (reset) begin
			q <= 32'h1;
		end else begin
			// Calculate the feedback value
			wire feedback = q[0] ^ q[21] ^ q[30] ^ q[31]; //Corrected tap positions

			// Shift and update
			q <= {feedback, q[31:1]};
		end
	end

endmodule