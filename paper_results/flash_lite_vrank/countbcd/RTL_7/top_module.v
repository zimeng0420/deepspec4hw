module top_module(
	input clk,
	input reset,
	output [3:1] ena,
	output reg [15:0] q);

	reg [3:0] ones;
	reg [3:0] tens;
	reg [3:0] hundreds;
	reg [3:0] thousands;

	assign ena[1] = (ones == 4'd9);
	assign ena[2] = (tens == 4'd9) & ena[1];
	assign ena[3] = (hundreds == 4'd9) & ena[2];

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			ones <= 4'd0;
			tens <= 4'd0;
			hundreds <= 4'd0;
			thousands <= 4'd0;
		end else begin
			if (ena[3]) begin
				thousands <= (thousands == 4'd9) ? 4'd0 : thousands + 4'd1;
			end
			if (ena[2]) begin
				hundreds <= (hundreds == 4'd9) ? 4'd0 : hundreds + 4'd1;
			end
			if (ena[1]) begin
				tens <= (tens == 4'd9) ? 4'd0 : tens + 4'd1;
			end
			ones <= (ones == 4'd9) ? 4'd0 : ones + 4'd1;
		end
	end

	always @(*) begin
		q[3:0] = ones;
		q[7:4] = tens;
		q[11:8] = hundreds;
		q[15:12] = thousands;
	end
endmodule