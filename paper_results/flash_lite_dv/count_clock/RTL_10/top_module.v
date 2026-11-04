module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Internal signals for seconds
    reg [3:0] ss_ones, ss_tens;

    // Internal signals for minutes
    reg [3:0] mm_ones, mm_tens;

    // Internal signals for hours
    reg [3:0] hh_ones, hh_tens;

    // Auxiliary signals
    reg sec_tick;

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            ss_ones <= 4'd0;
            ss_tens <= 4'd0;
        end else if (ena) begin
            if (ss_ones == 4'd9) begin
                ss_ones <= 4'd0;
                if (ss_tens == 4'd5) begin
                    ss_tens <= 4'd0;
                    sec_tick <= 1'b1;
                end else
                    ss_tens <= ss_tens + 1'b1;
            end else begin
                ss_ones <= ss_ones + 1'b1;
                sec_tick <= 1'b0;
            end
        end else
            sec_tick <= 1'b0;
    end

    // Minutes counter
    always @(posedge clk) begin
        if (reset) begin
            mm_ones <= 4'd0;
            mm_tens <= 4'd0;
        end else if (ena && sec_tick) begin
            if (mm_ones == 4'd9) begin
                mm_ones <= 4'd0;
                if (mm_tens == 4'd5) begin
                    mm_tens <= 4'd0;
                end else
                    mm_tens <= mm_tens + 1'b1;
            end else
                mm_ones <= mm_ones + 1'b1;
        end
    end

    // Hours counter
    always @(posedge clk) begin
        if (reset) begin
            hh_ones <= 4'd2;
            hh_tens <= 4'd1;
            pm <= 1'b0; // AM
        end else if (ena && sec_tick && mm_ones == 4'd0 && mm_tens == 4'd0) begin
            if (hh_ones == 4'd9 && hh_tens == 4'd1) begin // 10:59:59 to 11:00:00
                hh_ones <= 4'd0;
                hh_tens <= 4'd1;
            end
             else if (hh_ones == 4'd2 && hh_tens == 4'd1) begin  //12:59:59 to 01:00:00
                    hh_ones <= 4'd1;
                    hh_tens <= 4'd0;
                    pm <= ~pm;
            end
            else if (hh_ones == 4'd9) {
                hh_ones <= 4'd0;
                hh_tens <= hh_tens + 1'b1;
            }
             else if (hh_ones == 4'd2 && hh_tens == 4'd0) {
                hh_ones <= 4'd1;
                hh_tens <= 4'd0;
            } else if (hh_ones < 4'd9)
                hh_ones <= hh_ones + 1'b1;

            else if(hh_ones == 4'd9 && hh_tens == 4'd0)
            begin
                hh_ones <= 4'd0;
                hh_tens <= 4'd1;
            end

            else
                hh_ones <= hh_ones + 1'b1;
        end
    end

    // Output assignments
    always @(*) begin
        ss = {ss_tens, ss_ones};
        mm = {mm_tens, mm_ones};
        hh = {hh_tens, hh_ones};
    end

endmodule