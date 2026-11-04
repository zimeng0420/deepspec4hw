module top_module(
	input clk,
	input reset,
	input ena,
	output reg pm,
	output reg [7:0] hh,
	output reg [7:0] mm,
	output reg [7:0] ss
);

  // Internal registers for seconds, minutes, hours
  reg [3:0] ss_ones;
  reg [3:0] ss_tens;
  reg [3:0] mm_ones;
  reg [3:0] mm_tens;
  reg [3:0] hh_ones;
  reg [3:0] hh_tens;

  // Intermediate signals for BCD conversion
  always @(posedge clk) begin
    if (reset) begin
      pm <= 1'b0; // AM
      hh_tens <= 1'b1;
      hh_ones <= 2'b0010; // 12
      mm_tens <= 0;
      mm_ones <= 0;
      ss_tens <= 0;
      ss_ones <= 0;
    end
    else if (ena) begin
      // Seconds counter
      if (ss_ones == 9) begin
        ss_ones <= 0;
        if (ss_tens == 5) begin
          ss_tens <= 0;
          // Minutes counter
          if (mm_ones == 9) begin
            mm_ones <= 0;
            if (mm_tens == 5) begin
              mm_tens <= 0;
              // Hours counter
              if (hh_ones == 9) begin
                hh_ones <= 0;
                if (hh_tens == 1) begin
                  //check for 12 hour format
                  hh_tens <= 0;
                  hh_ones <= 2'b0010; //12
                  pm <= ~pm;
                end
                else if (hh_tens == 0) begin
                    hh_tens <= 1;
                    hh_ones <= 1;
                end

              end
              else if (hh_ones == 0 && hh_tens == 1) begin
                 hh_ones <= 2;
              end
              else begin
                hh_ones <= hh_ones + 1;
              end

            end
            else begin
              mm_tens <= mm_tens + 1;
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

  //BCD output conversion
  always @(*) begin
    ss = {ss_tens, ss_ones};
    mm = {mm_tens, mm_ones};

     if (hh_tens == 0 && hh_ones == 0) begin
         hh = 8'h12;
     end
     else if (hh_tens == 1 && hh_ones == 0) begin
         hh = 8'h10;
     end
    else begin
        hh = {hh_tens, hh_ones};
    end

  end

endmodule