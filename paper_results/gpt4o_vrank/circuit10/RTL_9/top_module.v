module top_module (
	input clk,
	input a,
	input b,
	output reg q,
	output reg state
);

	always @(posedge clk) begin
		state <= q;
		if (a == b) begin
			q <= 0;
		end else begin
			q <= 1;
		end
	end

endmodule