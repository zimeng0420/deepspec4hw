module top_module(
	input clk,
	input [7:0] in,
	output reg [7:0] anyedge
);

	reg [7:0] prev_in;
	reg [7:0] edge_detected;

	always @(posedge clk) begin
		// Detect edges (0 -> 1 or 1 -> 0)
		edge_detected = in ^ prev_in; // XOR to detect any change

		// Set anyedge one cycle after the edge is detected
		anyedge <= (edge_detected & ~anyedge);

		// Store the current input for the next cycle
		prev_in <= in;
	end

endmodule