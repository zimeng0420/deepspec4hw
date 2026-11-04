module top_module (
	input clk,
	input a, 
	output reg [2:0] q
);

	always @(posedge clk) begin
		if (a == 1'b1) begin
			q <= q; // Hold value when a is high
		end else begin
			q <= (q + 1) % 8; // Increment when a is low
		end
	end

endmodule