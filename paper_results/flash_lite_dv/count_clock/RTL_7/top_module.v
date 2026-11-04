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
            ss_ones <= 4'd0;
            ss_tens <= 4'd0;
            mm_ones <= 4'd0;
            mm_tens <= 4'd0;
            hh_ones <= 4'd2;
            hh_tens <= 4'd1;
            pm <= 1'b0; // AM
        end else begin
            if (ena) begin
                // Seconds counter
                if (ss_ones == 4'd9) begin
                    ss_ones <= 4'd0;
                    if (ss_tens == 4'd5) begin
                        ss_tens <= 4'd0;
                        // Minutes counter
                        if (mm_ones == 4'd9) begin
                            mm_ones <= 4'd0;
                            if (mm_tens == 4'd5) begin
                                mm_tens <= 4'd0;
                                // Hours counter
                                if (hh_ones == 4'd9) begin
                                    hh_ones <= 4'd0;
                                    if (hh_tens == 4'd1) begin
                                        hh_tens <= 4'd0;
                                        pm <= ~pm;
                                    end else begin
                                        hh_tens <= hh_tens + 1;
                                    end
                                end else if (hh_ones == 4'd2 && hh_tens == 4'd1) begin //12
                                  hh_ones <= 4'd1;
                                  hh_tens <= 4'd0;
                                  pm <= ~pm;
                                end else {
                                    hh_ones <= hh_ones +1;
                                }
                            end else begin
                                mm_tens <= mm_tens + 1;
                            end
                        end else {
                            mm_ones <= mm_ones + 1;
                        }
                    end else {
                        mm_tens <= mm_tens + 1;
                    }
                end else {
                    ss_ones <= ss_ones + 1;
                }
            end
        end
    end

    always @(*) begin
        ss = {ss_tens, ss_ones};
        mm = {mm_tens, mm_ones};
        hh = {hh_tens, hh_ones};
    end

endmodule