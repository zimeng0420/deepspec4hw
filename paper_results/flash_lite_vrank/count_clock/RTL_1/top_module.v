module top_module(
	input clk,
	input reset,
	input ena,
	output reg pm,
	output reg [7:0] hh,
	output reg [7:0] mm,
	output reg [7:0] ss);

	reg [3:0] ss_ones;
	reg [3:0] ss_tens;
	reg [3:0] mm_ones;
	reg [3:0] mm_tens;
	reg [3:0] hh_ones;
	reg [3:0] hh_tens;

	always @(posedge clk) begin
		if (reset) begin
			ss_ones <= 4'd0;
			ss_tens <= 4'd0;
			mm_ones <= 4'd0;
			mm_tens <= 4'd0;
			hh_ones <= 4'd2;
			hh_tens <= 4'd1;
			pm <= 1'b0;
		end else if (ena) begin
			// Seconds increment
			ss_ones <= ss_ones + 1;
			if (ss_ones == 4'd10) begin
				ss_ones <= 4'd0;
				ss_tens <= ss_tens + 1;
			end
			if (ss_tens == 4'd6) begin
				ss_tens <= 4'd0;
				// Minutes increment
				mm_ones <= mm_ones + 1;
				if (mm_ones == 4'd10) begin
					mm_ones <= 4'd0;
					mm_tens <= mm_tens + 1;
				end
				if (mm_tens == 4'd6) begin
					mm_tens <= 4'd0;
					// Hours increment
					hh_ones <= hh_ones + 1;
					if(hh_ones == 4'd10) begin
						hh_ones <= 4'd0;
						hh_tens <= hh_tens + 1;
					end
					if (hh_tens == 4'd1 && hh_ones == 4'd3) begin
						hh_tens <= 4'd0;
						hh_ones <= 4'd1;
						pm <= !pm;
					end else if (hh_tens == 4'd1 && hh_ones == 4'd2) begin
                        hh_tens <= 4'd0;
                        hh_ones <= 4'd1;
						pm <= !pm;
					end
					else if (hh_tens == 4'd0 && hh_ones == 4'd0) begin
						hh_tens <= 4'd1;
						hh_ones <= 4'd2;
					end
				end
			end
		end
	end

	always @(*) begin
		ss = (ss_tens << 4) | ss_ones;
		mm = (mm_tens << 4) | mm_ones;
		hh = (hh_tens << 4) | hh_ones;

		if (hh_tens == 4'd0 && hh_ones == 4'd0) begin
			hh = (4'd1 << 4) | 4'd2; // Handle 00 -> 12
		end
	end

endmodule