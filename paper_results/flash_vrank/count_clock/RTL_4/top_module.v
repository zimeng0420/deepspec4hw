module top_module(
	input clk,
	input reset,
	input ena,
	output reg pm,
	output reg [7:0] hh,
	output reg [7:0] mm,
	output reg [7:0] ss);

  reg [3:0] ss_lsb;
  reg [2:0] ss_msb;
  reg [3:0] mm_lsb;
  reg [2:0] mm_msb;
  reg [3:0] hh_lsb;
  reg [3:0] hh_msb;

  always @(posedge clk) begin
    if (reset) begin
      ss_lsb <= 4'd0;
      ss_msb <= 3'd0;
      mm_lsb <= 4'd0;
      mm_msb <= 3'd0;
      hh_lsb <= 4'd2;
      hh_msb <= 4'd1;
      pm <= 0;
    end else if (ena) begin
      // Seconds
      if (ss_lsb == 4'd9) begin
        ss_lsb <= 4'd0;
        if (ss_msb == 3'd5) begin
          ss_msb <= 3'd0;

          // Minutes
          if (mm_lsb == 4'd9) begin
            mm_lsb <= 4'd0;
            if (mm_msb == 3'd5) begin
              mm_msb <= 3'd0;

              // Hours
              if (hh_lsb == 4'd9) begin
                hh_lsb <= 4'd0;
                hh_msb <= 4'd1;
              end else if ({hh_msb, hh_lsb} == 8'b00010010) begin // 12
                hh_lsb <= 4'd1;
                hh_msb <= 4'd0;
                pm <= ~pm;
              end
              else if (hh_lsb == 4'd2 && hh_msb == 4'd1) begin
                hh_lsb <= 4'd1;
                hh_msb <= 4'd0;
              end
              else begin
                hh_lsb <= hh_lsb + 4'd1;
              end
            end else begin
              mm_msb <= mm_msb + 3'd1;
            end
          end else begin
            mm_lsb <= mm_lsb + 4'd1;
          end
        end else begin
          ss_msb <= ss_msb + 3'd1;
        end
      end else begin
        ss_lsb <= ss_lsb + 4'd1;
      end
    end
  end

  always @(*) begin
    hh = {hh_msb, hh_lsb};
    mm = {mm_msb, mm_lsb};
    ss = {ss_msb, ss_lsb};
  end

endmodule