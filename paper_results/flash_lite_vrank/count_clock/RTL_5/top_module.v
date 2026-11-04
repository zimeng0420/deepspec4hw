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
			pm <= 1'b0;
			hh_tens <= 1'b1;
			hh_ones <= 1'b0;
			mm_tens <= 0;
			mm_ones <= 0;
			ss_tens <= 0;
			ss_ones <= 0;
		end
		else if (ena) begin
			ss_ones <= ss_ones + 1;
			if (ss_ones == 4'd10) begin
				ss_ones <= 0;
				ss_tens <= ss_tens + 1;
				if (ss_tens == 4'd6) begin
					ss_tens <= 0;
					mm_ones <= mm_ones + 1;
					if (mm_ones == 4'd10) begin
						mm_ones <= 0;
						mm_tens <= mm_tens + 1;
						if (mm_tens == 4'd6) begin
							mm_tens <= 0;
							hh_ones <= hh_ones + 1;
							if (hh_ones == 4'd10) begin
								hh_ones <= 0;
								hh_tens <= hh_tens + 1;
								if (hh_tens == 1 && hh_ones == 4'd3) begin
									hh_tens <= 1;
									hh_ones <= 2;
									pm <= ~pm;
								end
								else if(hh_tens == 1 && hh_ones == 4'd2)
								begin
									hh_tens <= 1;
									hh_ones <= 1;
								end

								else begin
									hh_tens <= 0;
									hh_ones <= 1;
									if (hh_tens == 0 && hh_ones == 0) begin
										hh_tens <= 1;
										hh_ones <= 2;
									end
									else if (hh_tens == 0 && hh_ones == 1)
									begin
										hh_tens <= 0;
										hh_ones <= 2;
									end
									else if (hh_tens == 1 && hh_ones == 3) begin
										hh_tens <= 1;
										hh_ones <= 1;
									end
								end
							end
							else if(hh_tens == 0 && hh_ones == 3)
								begin
									hh_ones <= 1;
									hh_tens <= 0;
								end
						end
					end
					else if(mm_tens == 4 && mm_ones == 9)
					begin
					    mm_ones <=0;
					    mm_tens <= 0;
					    hh_ones <= hh_ones + 1;
					    if (hh_ones == 4'd10) begin
								hh_ones <= 0;
								hh_tens <= hh_tens + 1;
								if (hh_tens == 1 && hh_ones == 4'd3) begin
									hh_tens <= 1;
									hh_ones <= 2;
									pm <= ~pm;
								end
								else if(hh_tens == 1 && hh_ones == 4'd2)
								begin
									hh_tens <= 1;
									hh_ones <= 1;
								end
							end
					end
				end
			end
		end
	end

	always @(*) begin
		hh = (hh_tens << 4) | hh_ones;
		mm = (mm_tens << 4) | mm_ones;
		ss = (ss_tens << 4) | ss_ones;
	end

endmodule