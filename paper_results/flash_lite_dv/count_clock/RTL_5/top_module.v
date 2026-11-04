module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Internal registers for seconds
    reg [3:0] ss_ones;
    reg [3:0] ss_tens;

    // Internal registers for minutes
    reg [3:0] mm_ones;
    reg [3:0] mm_tens;

    // Internal registers for hours
    reg [3:0] hh_ones;
    reg [3:0] hh_tens;

    // Helper parameters for BCD representation
    parameter BCD_ZERO = 4'd0;
    parameter BCD_NINE = 4'd9;
    parameter BCD_ONE = 4'd1;
    parameter BCD_TWO = 4'd2;

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            hh_tens <= BCD_ONE;
            hh_ones <= BCD_TWO;
            mm_tens <= BCD_ZERO;
            mm_ones <= BCD_ZERO;
            ss_tens <= BCD_ZERO;
            ss_ones <= BCD_ZERO;
            pm <= 1'b0; // AM
        end else begin
            if (ena) begin
                // Seconds counter logic
                if (ss_ones == BCD_NINE) begin
                    if (ss_tens == 4'd5) begin
                        ss_tens <= BCD_ZERO;
                        ss_ones <= BCD_ZERO;
                    end else begin
                        ss_ones <= BCD_ZERO;
                        ss_tens <= ss_tens + BCD_ONE;
                    end
                end else begin
                    ss_ones <= ss_ones + BCD_ONE;
                end

                // Minutes counter logic
                if (ss_ones == BCD_ZERO && ss_tens == BCD_ZERO) begin // Seconds roll over
                    if (mm_ones == BCD_NINE) begin
                        if (mm_tens == 4'd5) begin
                            mm_tens <= BCD_ZERO;
                            mm_ones <= BCD_ZERO;
                        end else begin
                            mm_ones <= BCD_ZERO;
                            mm_tens <= mm_tens + BCD_ONE;
                        end
                    end else begin
                        mm_ones <= mm_ones + BCD_ONE;
                    end
                end

                // Hours counter logic
                if (ss_ones == BCD_ZERO && ss_tens == BCD_ZERO && mm_ones == BCD_ZERO && mm_tens == BCD_ZERO) begin // Minutes roll over
                    if (hh_ones == BCD_TWO && hh_tens == BCD_ONE) begin // 12:59:59
                        hh_ones <= BCD_ONE;
                        hh_tens <= BCD_ZERO;
                        pm <= ~pm; // Toggle AM/PM
                    end else if (hh_ones == BCD_NINE && hh_tens == BCD_ONE) begin // 10:59:59
                        hh_ones <= BCD_ZERO;
                    end else if (hh_ones == BCD_NINE && hh_tens == BCD_ZERO) begin // 09:59:59
                        hh_ones <= BCD_ZERO;
                        hh_tens <= BCD_ONE;
                    end

                     else if (hh_ones == BCD_ONE) begin // 01:59:59
                        hh_ones <= BCD_TWO;
                    end

                    else if (hh_ones == BCD_NINE && hh_tens == BCD_ZERO) begin  // 09:59:59
                        hh_ones <= BCD_ZERO;
                        hh_tens <= BCD_ONE;
                    end

                   else if (hh_ones == BCD_ONE && hh_tens == BCD_ZERO) begin // 01:59:59
                        hh_ones <= BCD_TWO;
                    end

                    else if (hh_ones == BCD_NINE) begin  // 10:59:59
                        hh_ones <= BCD_ZERO;
                        hh_tens <= hh_tens + BCD_ONE;
                    end

                    else if (hh_ones == BCD_NINE && hh_tens == BCD_ONE) begin  // 10:59:59
                         hh_ones <= BCD_ONE;
                    end

                     else begin
                        if (hh_ones == BCD_NINE)
                           begin
                               hh_ones <= BCD_ZERO;
                               hh_tens <= hh_tens + BCD_ONE;
                           end
                        else
                           hh_ones <= hh_ones + BCD_ONE;

                    end
                end
            end
        end
    end

    // Output assignments (BCD to 8-bit)
    always @(*) begin
        ss = {ss_tens, ss_ones};
        mm = {mm_tens, mm_ones};
        hh = {hh_tens, hh_ones};
    end

end