module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    reg [3:0] sec_tens;
    reg [3:0] sec_ones;
    reg [3:0] min_tens;
    reg [3:0] min_ones;
    reg [3:0] hour_tens;
    reg [3:0] hour_ones;

    always @(posedge clk) begin
        if (reset) begin
            hh <= 8'b00010000; // 12:00 AM
            mm <= 8'b00000000; // 00
            ss <= 8'b00000000; // 00
            pm <= 0;           // AM
            sec_tens <= 0;
            sec_ones <= 0;
            hour_tens <= 1;    // 1 for hour tens
            hour_ones <= 2;     // 2 for hour ones
            min_tens <= 0;      // Reset minutes
            min_ones <= 0;      // Reset minutes
        end else if (ena) begin
            if (sec_ones == 9) begin
                sec_ones <= 0;
                if (sec_tens == 5) begin
                    sec_tens <= 0;
                    // Increment minutes
                    if (min_ones == 9) begin
                        min_ones <= 0;
                        if (min_tens == 5) begin
                            min_tens <= 0;
                            // Increment hours
                            if (hour_ones == 9) begin
                                hour_ones <= 0;
                                if (hour_tens == 1 && hour_ones == 2) begin
                                    pm <= ~pm; // Toggle AM/PM
                                end
                                hour_tens <= hour_tens == 1 && hour_ones == 2 ? 0 : hour_tens; // Reset hour tens after 12
                                hour_ones <= hour_ones == 9 ? 0 : hour_ones + 1;
                            end else begin
                                hour_ones <= hour_ones == 9 ? 0 : hour_ones + 1;
                            end
                        end else begin
                            min_ones <= min_ones + 1;
                        end
                    end else begin
                        sec_ones <= sec_ones + 1;
                    end
                end else begin
                    sec_ones <= sec_ones + 1;
                end
            end else begin
                sec_tens <= sec_tens + 1; // Just increment the tens of seconds on the first count
            end
        end
    end
endmodule