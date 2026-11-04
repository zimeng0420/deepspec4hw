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
			ss_ones <= ss_ones + 1;
			if (ss_ones == 4'd10) begin
				ss_ones <= 4'd0;
				ss_tens <= ss_tens + 1;
				if (ss_tens == 4'd6) begin
					ss_tens <= 4'd0;
					mm_ones <= mm_ones + 1;
					if (mm_ones == 4'd10) begin
						mm_ones <= 4'd0;
						mm_tens <= mm_tens + 1;
						if (mm_tens == 4'd6) begin
							mm_tens <= 4'd0;
							hh_ones <= hh_ones + 1;
							if (hh_ones == 4'd10) begin
								hh_ones <= 4'd0;
								hh_tens <= hh_tens + 1;
								if (hh_tens == 4'd1) begin
									if (hh_ones == 4'd3) begin
										hh_tens <= 4'd0;
										hh_ones <= 4'd1;
										pm <= ~pm;
									end
								end else if (hh_tens == 4'd0) begin
									hh_ones <= 4'd1;
								end
							end else if (hh_ones == 4'd2 && hh_tens == 4'd1) begin
								hh_ones <= 4'd1;
								hh_tens <= 4'd0;
								pm <= ~pm;

							end
						end
					end
				end
			end
		end
		
		//BCD Conversion
		ss[3:0] <= ss_ones;
		ss[7:4] <= ss_tens;
		mm[3:0] <= mm_ones;
		mm[7:4] <= mm_tens;
		hh[3:0] <= hh_ones;
		hh[7:4] <= hh_tens;
	end
endmodule