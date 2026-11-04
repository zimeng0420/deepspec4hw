module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

  reg [3:0] ss_lsb;
  reg [2:0] ss_msb;
  reg [3:0] mm_lsb;
  reg [2:0] mm_msb;
  reg [3:0] hh_lsb;
  reg [3:0] hh_msb;


  always @(posedge clk) begin
    if (reset) begin
      ss_lsb <= 4'b0000;
      ss_msb <= 3'b000;
      mm_lsb <= 4'b0000;
      mm_msb <= 3'b000;
      hh_lsb <= 4'b0010;
      hh_msb <= 4'b0001;
      pm <= 1'b0;
    end else if (ena) begin
      // Seconds counter
      if (ss_lsb == 4'b1001) begin
        ss_lsb <= 4'b0000;
        if (ss_msb == 3'b010) begin
          ss_msb <= 3'b000;

          // Minutes counter
          if (mm_lsb == 4'b1001) begin
            mm_lsb <= 4'b0000;
            if (mm_msb == 3'b010) begin
              mm_msb <= 3'b000;

              // Hours counter
              if ((hh_msb == 4'b0001) && (hh_lsb == 4'b0010)) begin
                hh_lsb <= 4'b0001;
                hh_msb <= 4'b0000;
                pm <= ~pm;
              } else if (hh_lsb == 4'b1001) begin
                  hh_lsb <= 4'b0000;
                  hh_msb <= hh_msb + 1'b1;
              } else begin
                  hh_lsb <= hh_lsb + 1'b1;
              end
            end else begin
              mm_msb <= mm_msb + 1'b1;
            end
          end else begin
            mm_lsb <= mm_lsb + 1'b1;
          end
        end else begin
          ss_msb <= ss_msb + 1'b1;
        end
      end else begin
        ss_lsb <= ss_lsb + 1'b1;
      end
    end
  end

  always @(*) begin
    ss = {ss_msb, ss_lsb};
    mm = {mm_msb, mm_lsb};
    hh = {hh_msb, hh_lsb};
  end

endmodule