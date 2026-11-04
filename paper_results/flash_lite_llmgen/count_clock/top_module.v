module top_module(
	input clk,
	input reset,
	input ena,
	output reg pm,
	output reg [7:0] hh,
	output reg [7:0] mm,
	output reg [7:0] ss);

	// Internal Signals
	reg [3:0] ss_ones, ss_tens, mm_ones, mm_tens, hh_ones, hh_tens;
	wire carry_ss, carry_mm;

	// Seconds Counter Logic
	always @(posedge clk) begin
		if (reset) begin
			ss_ones <= 4'd0;
			ss_tens <= 4'd0;
		end else if (ena) begin
			if (ss_ones == 4'd9) begin
				ss_ones <= 4'd0;
			end else begin
				ss_ones <= ss_ones + 1'b1;
			end
		end
	end

	assign carry_ss = (ena && (ss_ones == 4'd9));

	always @(posedge clk) begin
		if (reset) begin
			ss_tens <= 4'd0;
		end else if (carry_ss) begin
			if (ss_tens == 4'd5) begin
				ss_tens <= 4'd0;
			end else begin
				ss_tens <= ss_tens + 1'b1;
			end
		end
	end

	// Minutes Counter Logic
	always @(posedge clk) begin
		if (reset) begin
			mm_ones <= 4'd0;
			mm_tens <= 4'd0;
		end else if (carry_ss) begin
			if (mm_ones == 4'd9) begin
				mm_ones <= 4'd0;
			end else begin
				mm_ones <= mm_ones + 1'b1;
			end
		end
	end

	assign carry_mm = (carry_ss && (mm_ones == 4'd9));

	always @(posedge clk) begin
		if (reset) begin
			mm_tens <= 4'd0;
		end else if (carry_mm) begin
			if (mm_tens == 4'd5) begin
				mm_tens <= 4'd0;
			end else begin
				mm_tens <= mm_tens + 1'b1;
			end
		end
	end

	// Hours Counter Logic
	always @(posedge clk) begin
		if (reset) begin
			hh_ones <= 4'd2;
			hh_tens <= 4'd1;
			pm <= 1'b0; // Initialize to AM
		end else if (carry_mm) begin
			if (hh_ones == 4'd9 && hh_tens == 4'd0) begin
				hh_ones <= 4'd1;
				hh_tens <= 4'd0;
				pm <= ~pm;
			end else if (hh_ones == 4'd2 && hh_tens == 4'd1) begin
				hh_ones <= 4'd1;
				hh_tens <= 4'd0;
				pm <= ~pm;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9 && hh_tens == 4'd0) begin
				hh_ones <= 4'd1;
				hh_tens <= 4'd0;
				pm <= ~pm;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0;
			end else if (hh_ones == 4'd9) begin
				hh_ones <= 4'd0