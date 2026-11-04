module top_module (
	input clk,
	input a, 
	output reg q
);
	always @(posedge clk) begin
		if (a) begin
			q <= 1'b0; // Reset q to 0 when a is high
		end else begin
			q <= ~q; // Toggle q when a is low
		end
	end
endmodule