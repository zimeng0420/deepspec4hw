module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss);

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            hh <= 8'b0001_0010; // 12 in BCD
            mm <= 8'b0000_0000; // 00 in BCD
            ss <= 8'b0000_0000; // 00 in BCD
            pm <= 0; // AM
        end else if (ena) begin
            // Increment seconds
            if (ss == 8'b0101_1001) begin // 59 in BCD
                ss <= 8'b0000_0000;      // 00 in BCD

                // Increment minutes
                if (mm == 8'b0101_1001) begin // 59 in BCD
                    mm <= 8'b0000_0000;      // 00 in BCD

                    // Increment hours
                    if (hh == 8'b0001_0010) begin // 12 in BCD
                        hh <= 8'b0000_0001;      // 01 in BCD
                        pm <= ~pm;               // Toggle AM/PM
                    end else if (hh == 8'b0001_0001) begin // 11 in BCD
                        hh <= 8'b0001_0010;      // 12 in BCD
                        pm <= ~pm;               // Toggle AM/PM
                    end else begin
                        if (hh[3:0] == 4'b1001) begin // Ends in 9
                            hh <= {hh[7:4] + 1, 4'b0000}; // Move to next tens digit
                        end else begin
                            hh <= hh + 1; // Increment units
                        end
                    end
                end else begin
                    if (mm[3:0] == 4'b1001) begin // Ends in 9
                        mm <= {mm[7:4] + 1, 4'b0000}; // Move to next tens digit
                    end else begin
                        mm <= mm + 1; // Increment units
                    end
                end
            end else begin
                if (ss[3:0] == 4'b1001) begin // Ends in 9
                    ss <= {ss[7:4] + 1, 4'b0000}; // Move to next tens digit
                end else begin
                    ss <= ss + 1; // Increment units
                end
            end
        end
    end
endmodule