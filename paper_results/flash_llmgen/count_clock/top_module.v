module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

  // Helper function to increment a BCD digit
  function automatic [3:0] increment_bcd_digit (input [3:0] digit);
    if (digit == 4'd9) begin
      increment_bcd_digit = 4'd0;
    end else begin
      increment_bcd_digit = digit + 1'b1;
    end
  endfunction

  // Helper function to combine two BCD digits into a byte
  function automatic [7:0] combine_bcd_digits (input [3:0] msb, input [3:0] lsb);
    combine_bcd_digits = {msb, lsb};
  endfunction

  // Helper function to extract the MSB BCD digit from a byte
  function automatic [3:0] get_msb_digit (input [7:0] byte);
    get_msb_digit = byte[7:4];
  endfunction

  // Helper function to extract the LSB BCD digit from a byte
  function automatic [3:0] get_lsb_digit (input [7:0] byte);
    get_lsb_digit = byte[3:0];
  endfunction


  reg [3:0] ss_lsb;
  reg [3:0] ss_msb;
  reg [3:0] mm_lsb;
  reg [3:0] mm_msb;
  reg [3:0] hh_lsb;
  reg [3:0] hh_msb;


  always @(posedge clk) begin
    if (reset) begin
      hh <= 8'h12;
      mm <= 8'h00;
      ss <= 8'h00;
      pm <= 0;

      ss_lsb <= 4'h0;
      ss_msb <= 4'h0;
      mm_lsb <= 4'h0;
      mm_msb <= 4'h0;
      hh_lsb <= 4'h2;
      hh_msb <= 4'h1;

    end else if (ena) begin

      // Increment Seconds
      ss_lsb <= increment_bcd_digit(ss_lsb);
      if (ss_lsb == 4'h0) begin
        ss_msb <= increment_bcd_digit(ss_msb);
        if (ss_msb == 4'h6) begin
          ss_msb <= 4'h0;

          // Increment Minutes
          mm_lsb <= increment_bcd_digit(mm_lsb);
          if (mm_lsb == 4'h0) begin
            mm_msb <= increment_bcd_digit(mm_msb);
            if (mm_msb == 4'h6) begin
              mm_msb <= 4'h0;

              // Increment Hours
              if (hh == 8'h11) begin
                hh_lsb <= 4'h2;
                hh_msb <= 4'h1;
                pm <= ~pm; // Toggle AM/PM
              end else if (hh == 8'h12) begin
                hh_lsb <= 4'h1;
                hh_msb <= 4'h0;
              end else begin
                if (hh_lsb == 4'h9) begin
                  hh_lsb <= 4'h0;
                  hh_msb <= hh_msb + 1'b1;
                end else begin
                  hh_lsb <= hh_lsb + 1'b1;
                end
              end
            end
          end
        end
      end

      ss <= combine_bcd_digits(ss_msb, ss_lsb);
      mm <= combine_bcd_digits(mm_msb, mm_lsb);
      hh <= combine_bcd_digits(hh_msb, hh_lsb);
    end
  end

endmodule