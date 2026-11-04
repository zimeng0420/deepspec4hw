module top_module(
	input clk,
	input reset,
	input ena,
	output reg pm,
	output reg [7:0] hh,
	output reg [7:0] mm,
	output reg [7:0] ss);

  reg [3:0] ss_lsb;
  reg [3:0] ss_msb;
  reg [3:0] mm_lsb;
  reg [3:0] mm_msb;
  reg [3:0] hh_lsb;
  reg [3:0] hh_msb;

  always @(posedge clk) begin
    if (reset) begin
      ss_lsb <= 4'b0000;
      ss_msb <= 4'b0000;
      mm_lsb <= 4'b0000;
      mm_msb <= 4'b0000;
      hh_lsb <= 4'b0010;
      hh_msb <= 4'b0001;
      pm <= 0;
    end else if (ena) begin
      if (ss_lsb == 4'b1001) begin
        ss_lsb <= 4'b0000;
        if (ss_msb == 4'b0101) begin
          ss_msb <= 4'b0000;
          if (mm_lsb == 4'b1001) begin
            mm_lsb <= 4'b0000;
            if (mm_msb == 4'b0101) begin
              mm_msb <= 4'b0000;
              if (hh_lsb == 4'b1001) begin
                hh_lsb <= 4'b0000;
                if (hh_msb == 4'b0001) begin
                  hh_msb <= 4'b0001;
                  hh_lsb <= 4'b0001;
                  pm <= ~pm;
                end else begin
                  hh_msb <= 4'b0001;
                  hh_lsb <= 4'b0001;
                end
              end else if ({hh_msb, hh_lsb} == 4'b0001) begin
                  hh_msb <= 4'b0001;
                  hh_lsb <= 4'b0010;
              end
               else if ({hh_msb, hh_lsb} == 4'b0011) begin
                hh_msb <= 4'b0000;
                hh_lsb <= 4'b0001;
               end
               else begin
                  hh_lsb <= hh_lsb + 4'b0001;
              end
            end else begin
              mm_msb <= mm_msb + 4'b0001;
            end
          end else begin
            mm_lsb <= mm_lsb + 4'b0001;
          end
        end else begin
          ss_msb <= ss_msb + 4'b0001;
        end
      end else begin
        ss_lsb <= ss_lsb + 4'b0001;
      end
    end
  end

  always @(*) begin
    hh = {hh_msb, hh_lsb};
    mm = {mm_msb, mm_lsb};
    ss = {ss_msb, ss_lsb};
  end

endmodule