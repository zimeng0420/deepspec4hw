module top_module(
	input clk,
	input reset,
	input ena,
	output reg pm,
	output reg [7:0] hh,
	output reg [7:0] mm,
	output reg [7:0] ss);

	// Internal signals
	reg [3:0] ss_ones;
	reg [3:0] ss_tens;
	reg [3:0] mm_ones;
	reg [3:0] mm_tens;
	reg [3:0] hh_ones;
	reg [3:0] hh_tens;
	reg [3:0] am_pm_state;  // 0: AM, 1: PM

	// Parameters for BCD decoding
	localparam [3:0] MAX_SECONDS_ONES = 9;
	localparam [3:0] MAX_SECONDS_TENS = 5;
	localparam [3:0] MAX_MINUTES_ONES = 9;
	localparam [3:0] MAX_MINUTES_TENS = 5;
	localparam [3:0] MAX_HOURS_ONES = 9;
	localparam [3:0] MAX_HOURS_TENS = 1;
    localparam [3:0] MAX_HOURS_ONES_12 = 2;



	// Instantiate counters
	always @(posedge clk) begin
		if (reset) begin
			ss_ones <= 4'b0;
			ss_tens <= 4'b0;
			mm_ones <= 4'b0;
			mm_tens <= 4'b0;
			hh_ones <= 2;  // 12 AM starts as hh = 12
			hh_tens <= 1;
			am_pm_state <= 0; // AM
		end else if (ena) begin
			// Seconds counter
			if (ss_ones == MAX_SECONDS_ONES) begin
				ss_ones <= 4'b0;
				if (ss_tens == MAX_SECONDS_TENS) begin
					ss_tens <= 4'b0;

					// Minutes Counter
					if (mm_ones == MAX_MINUTES_ONES) begin
						mm_ones <= 4'b0;
						if (mm_tens == MAX_MINUTES_TENS) begin
							mm_tens <= 4'b0;

							// Hours counter
							if (hh_ones == MAX_HOURS_ONES && hh_tens == MAX_HOURS_TENS) begin
								hh_ones <= 1;
								hh_tens <= 0;
								am_pm_state <= ~am_pm_state; // Toggle AM/PM
							end else if(hh_ones == MAX_HOURS_ONES_12 && hh_tens == MAX_HOURS_TENS) begin
                                hh_ones <= 1;
                                hh_tens <= 0;
                                am_pm_state <= ~am_pm_state; // Toggle AM/PM
                            end
							else if (hh_ones == MAX_HOURS_ONES) begin
								hh_ones <= 0;
								hh_tens <= hh_tens + 1'b1;
							end
							else begin
								hh_ones <= hh_ones + 1'b1;
							end

						end else begin
							mm_tens <= mm_tens + 1'b1;
						end
					end else begin
						mm_ones <= mm_ones + 1'b1;
					end
				end else begin
					ss_tens <= ss_tens + 1'b1;
				end
			end else begin
				ss_ones <= ss_ones + 1'b1;
			end
		end
	end


	// Assign BCD outputs
	always @(*) begin
		ss = (ss_tens << 4) | ss_ones;
		mm = (mm_tens << 4) | mm_ones;
		hh = (hh_tens << 4) | hh_ones;

		if (am_pm_state == 1)
			pm = 1;
		else
			pm = 0;
	end

endmodule