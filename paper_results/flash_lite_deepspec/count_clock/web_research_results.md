# Web Research Results

Total Results: 1

## Result 1

A BCD (Binary Coded Decimal) counter is a type of digital counter designed to count ten digits. It counts from 0 to 9 and then resets. This counter is often used for decimal displays and other human interface hardware.

Here's a module suitable for a 12-hour clock with an AM/PM indicator, using BCD counters for hours, minutes, and seconds, as requested:

```verilog
module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Internal signals for seconds, minutes, and hours BCD counters
    reg [3:0] ss_ones, ss_tens;
    reg [3:0] mm_ones, mm_tens;
    reg [3:0] hh_ones, hh_tens;

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            ss_ones <= 4'd0;
            ss_tens <= 4'd0;
        end else if (ena) begin
            ss_ones <= (ss_ones == 4'd9) ? 4'd0 : ss_ones + 1;
            if (ss_ones == 4'd9) begin
                ss_tens <= (ss_tens == 4'd5) ? 4'd0 : ss_tens + 1;
            end
        end
    end

    // Minutes counter
    always @(posedge clk) begin
        if (reset) begin
            mm_ones <= 4'd0;
            mm_tens <= 4'd0;
        end else if (ena && ss_ones == 4'd0 && ss_tens == 4'd0) begin // Increment minutes on second rollover
            mm_ones <= (mm_ones == 4'd9) ? 4'd0 : mm_ones + 1;
            if (mm_ones == 4'd9) begin
                mm_tens <= (mm_tens == 4'd5) ? 4'd0 : mm_tens + 1;
            end
        end
    end

    // Hours counter
    always @(posedge clk) begin
        if (reset) begin
            hh_ones <= 4'd2;
            hh_tens <= 4'd1;
            pm <= 1'b0; // Initialize to AM
        end else if (ena && mm_ones == 4'd0 && mm_tens == 4'd0 && ss_ones == 4'd0 && ss_tens == 4'd0) begin // Increment hours on minute rollover
            if (hh_ones == 4'd9 && hh_tens == 4'd1) begin // 12:59:59
                hh_ones <= 4'd1;
                hh_tens <= 4'd0;
                pm <= ~pm; // Toggle AM/PM
            end else if (hh_ones == 4'd2 && hh_tens == 4'd0) begin // 10:59:59
                hh_ones <= 4'd1;
                hh_tens <= 4'd0;
            end
            else if (hh_ones == 4'd9) begin
                hh_ones <= 4'd0;
                hh_tens <= hh_tens + 1;
            end
            else if (hh_tens == 4'd1 && hh_ones == 4'd2) {
                hh_ones <= 4'd1;
                hh_tens <= 4'd0;
                pm <= ~pm;
            }
            else
                hh_ones <= hh_ones + 1;
        end
    end

    // Assign BCD values to output registers
    always @(*) begin
        ss = {ss_tens, ss_ones};
        mm = {mm_tens, mm_ones};
        if (hh_tens == 4'd0)
            hh = {1'b0, hh_ones};
        else
            hh = {hh_tens, hh_ones};
    end
endmodule
```

---

