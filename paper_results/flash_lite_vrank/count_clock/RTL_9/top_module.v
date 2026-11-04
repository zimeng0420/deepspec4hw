module top_module(
	input clk,
	input reset,
	input ena,
	output reg pm,
	output reg [7:0] hh,
	output reg [7:0] mm,
	output reg [7:0] ss);

	// Internal registers for seconds, minutes, and hours
	reg [3:0] ss_ones, ss_tens;
	reg [3:0] mm_ones, mm_tens;
	reg [3:0] hh_ones, hh_tens;

	// Helper signals
	reg sec_tick;
	reg [1:0] hour_mode; // 00: AM, 01: PM, 10: (unused), 11: (unused)

	// 1-second counter (synchronous to clk)
	always @(posedge clk) begin
		if (reset) begin
			ss_ones <= 4'd0;
			ss_tens <= 4'd0;
			mm_ones <= 4'd0;
			mm_tens <= 4'd0;
			hh_ones <= 4'd2;
			hh_tens <= 4'd1;
			hour_mode <= 0;
			sec_tick <= 1'b0;
		end else if (ena) begin
			if (ss_ones == 4'd9) begin
				ss_ones <= 4'd0;
				if (ss_tens == 4'd5) begin
					ss_tens <= 4'd0;
					sec_tick <= 1'b1;
				end else
					ss_tens <= ss_tens + 1'b1;
					sec_tick <= 1'b0;

			end else begin
				ss_ones <= ss_ones + 1'b1;
				sec_tick <= 1'b0;
			end
		end else begin
			sec_tick <= 1'b0;
		end
	end

	// Minute and Hour update logic
	always @(posedge clk) begin
		if(reset) begin
			mm_ones <= 4'd0;
			mm_tens <= 4'd0;
			hh_ones <= 4'd2;
			hh_tens <= 4'd1;
			hour_mode <= 0;
		end
		else if(sec_tick) begin
			if (mm_ones == 4'd9) begin
				mm_ones <= 4'd0;
				if (mm_tens == 4'd5) begin
					mm_tens <= 4'd0;
					if (hh_ones == 4'd9) begin
                        hh_ones <= 4'd0;
                        if(hh_tens == 4'd1)
                        begin
                            hh_tens <= 4'd2;
                            hour_mode <= (hour_mode == 0) ? 1 : 0;
                        end
                        else if (hh_tens == 4'd2)
                        {
                            hh_tens <= 4'd1;
                        }

					end else if (hh_ones == 4'd2 && hh_tens == 4'd1) begin
							hh_ones <= 4'd1;
							hh_tens <= 4'd0;
							hour_mode <= (hour_mode == 0) ? 1 : 0;


					end
					else {
						if (hh_ones == 4'd0) {
                            hh_ones <= 4'd1;
                            hh_tens <= hh_tens + 1'b1;
                        }
						else
							hh_ones <= hh_ones + 1'b1;
						if (hh_tens == 4'd1 && hh_ones == 4'd3) {
                            hh_ones <= 4'd1;
                            hh_tens <= 4'd0;
                            hour_mode <= (hour_mode == 0) ? 1 : 0;
                        }
					}
				} else
					mm_tens <= mm_tens + 1'b1;
			end else
				mm_ones <= mm_ones + 1'b1;
		end
	end


	// Output assignments (BCD conversion)
	always @(*) begin
		ss = {ss_tens, ss_ones};
		mm = {mm_tens, mm_ones};
		hh = {hh_tens, hh_ones};
		pm = (hour_mode == 1) ? 1'b1 : 1'b0;
	end

end