module top_module(
	input clk,
	input d,
	output reg q
);

	reg d_rising, d_falling;

	always @(posedge clk) begin
		d_rising <= d; // Sample d on rising edge
	end
	
	always @(negedge clk) begin
		d_falling <= d; // Sample d on falling edge
	end
	
	always @(*) begin
		q = (clk) ? d_rising : d_falling; // Select between the two sampled values
	end

endmodule