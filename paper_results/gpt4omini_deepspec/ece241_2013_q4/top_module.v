module top_module (
	input clk,
	input reset,
	input [3:1] s,
	output reg fr3,
	output reg fr2,
	output reg fr1,
	output reg dfr
);

reg [3:1] previous_s;

always @(posedge clk or posedge reset) begin
	if (reset) begin
		fr3 <= 1'b1;
		fr2 <= 1'b1;
		fr1 <= 1'b1;
		dfr <= 1'b1;
		previous_s <= 3'b000;
	end else begin
		fr3 <= (s[1] == 1'b0);
		fr2 <= (s[1] == 1'b1 && s[3] == 1'b0);
		fr1 <= (s[2] == 1'b1 || s[1] == 1'b0);

		if (s != previous_s) begin
			if (previous_s < s) begin
				dfr <= 1'b1;
			end else begin
				dfr <= 1'b0;
			end
		end
		previous_s <= s;
	end
end

endmodule