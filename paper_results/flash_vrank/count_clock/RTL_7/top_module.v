module top_module(
	input clk,
	input reset,
	input ena,
	output reg pm,
	output reg [7:0] hh,
	output reg [7:0] mm,
	output reg [7:0] ss);

  reg [3:0] ss_low;
  reg [2:0] ss_high;
  reg [3:0] mm_low;
  reg [2:0] mm_high;
  reg [3:0] hh_low;
  reg [3:0] hh_high;

  always @(posedge clk) begin
    if (reset) begin
      ss_low <= 4'b0000;
      ss_high <= 3'b000;
      mm_low <= 4'b0000;
      mm_high <= 3'b000;
      hh_low <= 4'b0010;
      hh_high <= 4'b0001;
      pm <= 0;
    end else if (ena) begin
      // Seconds counter
      if (ss_low == 4'b1001) begin
        ss_low <= 4'b0000;
        if (ss_high == 3'b101) begin
          ss_high <= 3'b000;
          // Minutes counter
          if (mm_low == 4'b1001) begin
            mm_low <= 4'b0000;
            if (mm_high == 3'b101) begin
              mm_high <= 3'b000;
              // Hours counter
              if (hh_low == 4'b1001) begin
                hh_low <= 4'b0000;
                hh_high <= 4'b0001;
              end else if ({hh_high, hh_low} == 8) begin
                  hh_low <= hh_low + 1;
              end else if ({hh_high, hh_low} == 11)begin
                  hh_low <= hh_low + 1;
                  pm <= ~pm;
              end
              else begin
                hh_low <= hh_low + 1;
              end

            end else begin
              mm_high <= mm_high + 1;
            end
          end else begin
            mm_low <= mm_low + 1;
          end
        end else begin
          ss_high <= ss_high + 1;
        end
      end else begin
        ss_low <= ss_low + 1;
      end
    end
  end

  always @(*) begin
    hh = {hh_high, hh_low};
    mm = {mm_high, mm_low};
    ss = {ss_high, ss_low};
  end

endmodule