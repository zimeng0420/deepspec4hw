module top_module(
	input clk,
	input d,
	output reg q
);

	reg q_posedge;
	reg q_negedge;

	always @(posedge clk) begin
		q_posedge <= d;
	end

	always @(negedge clk) begin
		q_negedge <= d;
	end

	always @(posedge clk) begin
		q <= q_posedge; // Update q on the next posedge, effectively capturing data on both edges.
	end


endmodule