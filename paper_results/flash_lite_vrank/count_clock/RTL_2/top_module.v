module top_module(
	input clk,
	input reset,
	input ena,
	output reg pm,
	output reg [7:0] hh,
	output reg [7:0] mm,
	output reg [7:0] ss);

	// Internal signals
	reg [3:0] ss_ones, ss_tens;
	reg [3:0] mm_ones, mm_tens;
	reg [3:0] hh_ones, hh_tens;
	reg [1:0] hh_reg;

	// Clock divider (example - adjust for your clk frequency)
	reg [23:0] clk_counter;
	wire tick;

	always @(posedge clk) begin
		clk_counter <= clk_counter + 1;
	end

	assign tick = (clk_counter == 24'd999999); // Example:  1 MHz clk, tick every 1 second. Adjust value.

	// Seconds counter
	always @(posedge clk) begin
		if (reset) begin
			ss_ones <= 4'd0;
			ss_tens <= 4'd0;
		end else if (ena && tick) begin
			if (ss_ones == 4'd9) begin
				ss_ones <= 4'd0;
				if (ss_tens == 4'd5) begin
					ss_tens <= 4'd0;
				end else begin
					ss_tens <= ss_tens + 1;
				end
			end else begin
				ss_ones <= ss_ones + 1;
			end
		end
	end

	always @(*) begin
		ss = (ss_tens << 4) | ss_ones;
	end

	// Minutes counter
	always @(posedge clk) begin
		if (reset) begin
			mm_ones <= 4'd0;
			mm_tens <= 4'd0;
		end else if (ena && tick && ss_ones == 4'd9 && ss_tens == 4'd5) begin
			if (mm_ones == 4'd9) begin
				mm_ones <= 4'd0;
				if (mm_tens == 4'd5) begin
					mm_tens <= 4'd0;
				end else begin
					mm_tens <= mm_tens + 1;
				end
			end else begin
				mm_ones <= mm_ones + 1;
			end
		end
	end

	always @(*) begin
		mm = (mm_tens << 4) | mm_ones;
	end

	// Hours counter and AM/PM indicator
	always @(posedge clk) begin
		if (reset) begin
			hh_ones <= 4'd2;
			hh_tens <= 4'd1;
			pm <= 1'b0; // AM
		end else if (ena && tick && mm_ones == 4'd9 && mm_tens == 4'd5 && ss_ones == 4'd9 && ss_tens == 4'd5) begin
			if (hh_ones == 4'd9) begin
                hh_ones <= 4'd0;
				if (hh_tens == 4'd1) begin
                    hh_tens <= 4'd0;
					pm <= ~pm; // Toggle AM/PM
				end else begin
                    hh_tens <= hh_tens +1;
                end
			end else if (hh_ones == 4'd2 && hh_tens == 4'd1) begin
                 hh_ones <= 4'd1;
				 hh_tens <= 4'd0;
				 pm <= ~pm;
			end else if (hh_ones == 4'd0 && hh_tens == 4'd1) begin
				hh_ones <= 4'd1;
				hh_tens <= 4'd0;
			end
			else begin
				if (hh_ones == 4'd9) begin
				    hh_ones <= 4'd1;
				    hh_tens <= 4'd0;

				end else if (hh_ones == 4'd1) begin
					hh_ones <= 4'd2;
				end
				else begin
					hh_ones <= hh_ones + 1;
				end
			end
		end
	end

	always @(*) begin
		hh = (hh_tens << 4) | hh_ones;
	end

	// always @(posedge clk) begin
	// 	if(reset) begin
	// 		hh_reg <= 2'b12;
	// 		pm <= 1'b0;
	// 	end else if (ena && tick && mm_ones == 4'd9 && mm_tens == 4'd5 && ss_ones == 4'd9 && ss_tens == 4'd5) begin
	// 		if(hh_reg == 2'd12) begin
	// 			hh_reg <= 2'd1;
	// 			pm <= ~pm;
	// 		end else begin
	// 			hh_reg <= hh_reg + 1;
	// 		end
	// 	end
	// 	// Hours
	// 	if(hh_reg <= 2'd9)
	// 		hh = {1'b0, hh_reg};
	// 	else
	// 		hh = hh_reg;
	// end

endmodule