module top_module(
	input clk,
	input [7:0] in,
	output reg [7:0] pedge
);

	reg [7:0] prev_in;
	reg [7:0] pedge_delayed;

	always @(posedge clk) begin
		prev_in <= in;
		pedge_delayed <= (in & ~prev_in); // Detect 0->1 transitions
	end

	always @(posedge clk) begin
		pedge <= pedge_delayed; // Delay the output by one cycle
	end

endmodule