module top_module(
	input clk,
	input reset,
	input ena,
	output reg pm,
	output reg [7:0] hh,
	output reg [7:0] mm,
	output reg [7:0] ss);

	// Internal registers for seconds
	reg [3:0] ss_ones;
	reg [3:0] ss_tens;

	// Internal registers for minutes
	reg [3:0] mm_ones;
	reg [3:0] mm_tens;

	// Internal registers for hours
	reg [3:0] hh_ones;
	reg [3:0] hh_tens;

	always @(posedge clk) begin
		if (reset) begin
			// Reset to 12:00 AM
			hh_tens <= 1;
			hh_ones <= 2;
			mm_tens <= 0;
			mm_ones <= 0;
			ss_tens <= 0;
			ss_ones <= 0;
			pm <= 0; // AM
		end else if (ena) begin
			// Seconds counter logic
			if (ss_ones == 9) begin
				if (ss_tens == 5) begin
					ss_tens <= 0;
					ss_ones <= 0;
				end else begin
					ss_tens <= ss_tens + 1;
					ss_ones <= 0;
				end
			end else begin
				ss_ones <= ss_ones + 1;
			end

			// Minutes counter logic
			if (ss_ones == 9 && ss_tens == 5) begin
				if (mm_ones == 9) begin
					if (mm_tens == 5) begin
						mm_tens <= 0;
						mm_ones <= 0;
					end else begin
						mm_tens <= mm_tens + 1;
						mm_ones <= 0;
					end
				end else begin
					mm_ones <= mm_ones + 1;
				end
			end

			// Hours counter logic
			if (ss_ones == 9 && ss_tens == 5 && mm_ones == 9 && mm_tens == 5) begin
				if (hh_ones == 9 && hh_tens == 1) begin
					hh_tens <= 0;
					hh_ones <= 0;
					pm <= ~pm;
				end else if (hh_ones == 2 && hh_tens == 1) begin
					hh_tens <= 0;
					hh_ones <= 1;
					pm <= ~pm;
				end else if (hh_ones == 9) begin
					hh_ones <= 0;
					hh_tens <= hh_tens + 1;
				end else if (hh_tens == 0 && hh_ones == 9) begin
					hh_tens <= 1;
					hh_ones <= 0;
				end
				else if (hh_ones == 9 && hh_tens == 0) begin
					hh_tens <= 1;
					hh_ones <= 0;
				end
				else begin
					if (hh_ones == 2) begin
						hh_tens <= hh_tens + 1;
						hh_ones <= 1;
					end
					else
						hh_ones <= hh_ones + 1;
				end
			end
		end
	end

	// Output assignments
	always @(*) begin
		ss = {ss_tens, ss_ones};
		mm = {mm_tens, mm_ones};
		hh = {hh_tens, hh_ones};
	end

endmodule