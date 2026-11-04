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
			mm_tens <= 4'b0;
			mm_ones <= 4'b0;
			ss_tens <= 4'b0;
			ss_ones <= 4'b0;
		end
		else if (ena) begin
			// Seconds counter
			if (ss_ones == 4'd9) begin
				ss_ones <= 4'b0;
				if (ss_tens == 4'd5) begin
					ss_tens <= 4'b0;
					// Minutes counter
					if (mm_ones == 4'd9) begin
						mm_ones <= 4'b0;
						if (mm_tens == 4'd5) begin
							mm_tens <= 4'b0;
							// Hours counter
							if (hh_ones == 4'd9 && hh_tens == 4'd1) begin
                                                            hh_ones <= 4'b2;
                                                            hh_tens <= 4'b0;
                                                            pm <= ~pm; // Toggle AM/PM
							end
                            else if (hh_ones == 4'd2 && hh_tens == 4'd1) begin
                                                            hh_ones <= 4'b1;
                                                            hh_tens <= 4'b0;
                                                            pm <= ~pm;
                                                    end

							else if (hh_ones == 4'd9 && hh_tens == 4'b0)
                            begin
                                hh_ones <= 4'b1;
                                hh_tens <= 4'b1;
                            end
                            else if (hh_ones == 4'd2) begin
                                    hh_ones <= 4'b1;
                                    hh_tens <= hh_tens + 1;
                                    if (hh_tens > 4'b1) begin
                                        hh_tens <= 4'b0;
                                    end
                            end
                            else begin
                                hh_ones <= hh_ones + 1;

                            end
						end
						else begin
							mm_tens <= mm_tens + 1;
							mm_ones <= 4'b0;
						end
					end
					else begin
						mm_ones <= mm_ones + 1;
					end
				end
				else begin
					ss_tens <= ss_tens + 1;
				end
			end
			else begin
				ss_ones <= ss_ones + 1;
			end
		end
	end

	always @(*) begin
		hh = (hh_tens << 4) | hh_ones;
		mm = (mm_tens << 4) | mm_ones;
		ss = (ss_tens << 4) | ss_ones;
	end

endmodule