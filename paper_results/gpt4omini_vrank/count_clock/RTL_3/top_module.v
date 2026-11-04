module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // BCD logic for seconds, minutes and hours
    reg [3:0] sec_ones, sec_tens;
    reg [3:0] min_ones, min_tens;
    reg [3:0] hr_ones, hr_tens;

    // Synchronize the counter with the fast clk
    always @(posedge clk) begin
        if (reset) begin
            // Reset the time to 12:00 AM
            hh <= 8'b00010000; // 12 in BCD
            mm <= 8'b00000000; // 00 in BCD
            ss <= 8'b00000000; // 00 in BCD
            pm <= 0;
        end else if (ena) begin
            // Increment seconds
            if (ss < 59) begin
                ss <= ss + 1;
            end else begin
                ss <= 0;
                // Increment minutes
                if (mm < 59) begin
                    mm <= mm + 1;
                end else begin
                    mm <= 0;
                    // Increment hours
                    if (hh == 8'b00011000) begin // If hh reaches 12 in BCD (00011000)
                        hh <= 8'b00010000; // Reset to 12 in BCD
                        pm <= ~pm; // Toggle AM/PM
                    end else begin
                        hh <= hh + 1; // Increment the hour
                    end
                end
            end
        end
    end
endmodule