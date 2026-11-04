module top_module(
	input clk,
	input reset,
	input ena,
	output reg pm,
	output reg [7:0] hh,
	output reg [7:0] mm,
	output reg [7:0] ss
);

	// Internal signals for seconds
	reg [3:0] ss_ones;
	reg [3:0] ss_tens;

	// Internal signals for minutes
	reg [3:0] mm_ones;
	reg [3:0] mm_tens;

	// Internal signals for hours
	reg [3:0] hh_ones;
	reg [3:0] hh_tens;

	// Internal signals for enabling the counters
	reg enable_ss;
	reg enable_mm;
	reg enable_hh;
	
	// Clock divider (assumed to be synchronous and generate enable signals)
	reg [25:0] counter;
	localparam CLK_DIV = 26'd1000000; // Adjust based on your clk frequency and desired second rate

	always @(posedge clk) begin
		if (reset) begin
			counter <= 0;
			enable_ss <= 0;
		end
		else begin
			counter <= counter + 1;
			if (counter == CLK_DIV -1) begin
				counter <= 0;
				enable_ss <= ena;
			end
			else
				enable_ss <= 0;

		end
	end

	// Seconds Counter
	always @(posedge clk) begin
		if (reset) begin
			ss_ones <= 4'd0;
			ss_tens <= 4'd0;
		end
		else if (enable_ss) begin
			if (ss_ones == 4'd9) begin
				ss_ones <= 4'd0;
				if (ss_tens == 4'd5) begin
					ss_tens <= 4'd0;
					enable_mm <= 1;
				end
				else begin
					ss_tens <= ss_tens + 1;
					enable_mm <= 0;
				end
			end
			else begin
				ss_ones <= ss_ones + 1;
				enable_mm <= 0;
			end
		end
		else
			enable_mm <= 0;
	end

	// Minutes Counter
	always @(posedge clk) begin
		if (reset) begin
			mm_ones <= 4'd0;
			mm_tens <= 4'd0;
		end
		else if (enable_mm) begin
			if (mm_ones == 4'd9) begin
				mm_ones <= 4'd0;
				if (mm_tens == 4'd5) begin
					mm_tens <= 4'd0;
					enable_hh <= 1;
				end
				else begin
					mm_tens <= mm_tens + 1;
					enable_hh <= 0;
				end
			end
			else begin
				mm_ones <= mm_ones + 1;
				enable_hh <= 0;
			end
		end
		else
			enable_hh <= 0;
	end

	// Hours Counter
	always @(posedge clk) begin
		if (reset) begin
			hh_ones <= 4'd2;
			hh_tens <= 4'd1;
			pm <= 0; // AM
		end
		else if (enable_hh) begin
			if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
				if (hh_tens == 4'd1) begin
					hh_tens <= 4'd2;
					pm <= pm; // Do not change am/pm when 19 becomes 20
				end
				else if(hh_tens == 4'd2)
				begin
					hh_ones <= 4'd1;
					hh_tens <= 4'd0;
					pm <= !pm;
				end
			end
			else if (hh_ones == 4'd2 && hh_tens == 4'd1) begin // 19:xx:xx
				hh_ones <= 4'd0;
				hh_tens <= 4'd1;
				pm <= !pm;
			end

			else if (hh_ones == 4'd2 && hh_tens == 4'd0) begin
				hh_ones <= 4'd1;
				hh_tens <= 4'd0;
				pm <= !pm;
			end
			else if (hh_ones == 4'd2 && hh_tens == 4'd2) begin
					hh_ones <= 4'd0;
					hh_tens <= 4'd1;

			end
			else if (hh_ones == 4'd9 && hh_tens == 4'd0) begin
				hh_ones <= 4'd1;
				hh_tens <= 4'd0;
			end
			else if (hh_ones == 4'd0 && hh_tens == 4'd0) begin // reset condition, 00:xx:xx
                hh_ones <= 4'd1;
                hh_tens <= 4'd2;
                pm <= !pm;

			end
			else if (hh_ones == 4'd2)
			begin
					hh_ones <= 4'd1;
					hh_tens <= 4'd0;
					pm <= !pm;
			end
			else if (hh_ones == 4'd1 && hh_tens == 4'd2)
			begin
				hh_ones <= 4'd1;
				hh_tens <= 4'd0;
				pm <= !pm;
			end
			else begin
				if (hh_ones == 4'd9)
				begin
					hh_ones <= 4'd0;
					if (hh_tens == 4'd1)
					begin
						hh_tens <= 4'd0;
						pm <= !pm;
					end
					else
						hh_tens <= hh_tens +1;

				end

				else if(hh_ones == 4'd2)
				begin
					hh_ones <= 4'd1;
					hh_tens <= 4'd0;
					pm <= !pm;
				end
				else
					hh_ones <= hh_ones + 1;
			end
		end
	end

	// Output assignments (BCD conversion)
	always @(*) begin
		ss = (ss_tens << 4) | ss_ones;
		mm = (mm_tens << 4) | mm_ones;
		hh = (hh_tens << 4) | hh_ones;

		// Handle the 12:00 AM reset to ensure it does not stay at "12"
		if (reset) begin
			hh = 8'h12;
			mm = 8'h00;
			ss = 8'h00;
			pm = 0; // AM
		end

		// Adjust for the 12 hour clock if necessary, considering the reset
		if (!reset && hh_tens == 4'd0 && hh_ones == 4'd0) begin
            hh = 8'h12;
        end
	end

end