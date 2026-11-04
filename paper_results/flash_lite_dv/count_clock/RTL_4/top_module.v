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

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00 AM
            hh_tens <= 1;
            hh_ones <= 2;
            mm_tens <= 0;
            mm_ones <= 0;
            ss_tens <= 0;
            ss_ones <= 0;
            pm <= 0; // AM
        end else if (ena) begin
            // Seconds Counter
            if (ss_ones == 9) begin
                if (ss_tens == 5) begin
                    ss_tens <= 0;
                    ss_ones <= 0;

                    // Minutes Counter
                    if (mm_ones == 9) begin
                        if (mm_tens == 5) begin
                            mm_tens <= 0;
                            mm_ones <= 0;

                            // Hours Counter
                            if (hh_ones == 2 && hh_tens == 1) begin // 12:59:59
                                hh_tens <= 0;
                                hh_ones <= 1;
                                pm <= ~pm; // Toggle PM
                            end else if (hh_ones == 9 && hh_tens == 0) begin //09:59:59
                                hh_tens <= 1;
                                hh_ones <= 0;
                            end
                            else if (hh_ones == 9 && hh_tens == 1) begin //19:59:59
                                hh_tens <= 0;
                                hh_ones <= 0;
                            end
                             else if (hh_ones == 1 && hh_tens == 0) begin
                                 hh_ones <=2;
                             end

                            else begin
                                if (hh_ones == 9) begin
                                    hh_ones <= 0;
                                    hh_tens <= hh_tens + 1;
                                end
                                else if (hh_ones == 2 && hh_tens == 0) begin
                                    hh_ones <= 1;
                                    hh_tens <= 1;
                                end

                                else begin
                                    hh_ones <= hh_ones + 1;

                                end
                            end


                        end else begin
                            mm_ones <= 0;
                            mm_tens <= mm_tens + 1;
                        end
                    end else begin
                        mm_ones <= mm_ones + 1;
                    end
                end else begin
                    ss_ones <= 0;
                    ss_tens <= ss_tens + 1;
                end
            end else begin
                ss_ones <= ss_ones + 1;
            end
        end
    end

    always @(*) begin
        // Assign BCD outputs
        ss = {ss_tens, ss_ones};
        mm = {mm_tens, mm_ones};

        if (hh_tens == 0) begin
            hh = {4'b0, hh_ones}; // Handle leading zero
        end else {
            hh = {hh_tens, hh_ones};
        }
    end

endmodule