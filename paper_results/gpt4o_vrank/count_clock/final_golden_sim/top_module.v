module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    always @(posedge clk) begin
        if (reset) begin
            // Reset to "12:00:00 AM"
            hh <= 8'b0001_0010; // 12 in BCD
            mm <= 8'b0000_0000;
            ss <= 8'b0000_0000;
            pm <= 1'b0; // AM
        end
        else if (ena) begin
            // Increment seconds
            if (ss == 8'b0101_1001) begin // 59 in BCD
                ss <= 8'b0000_0000;
                // Increment minutes
                if (mm == 8'b0101_1001) begin // 59 in BCD
                    mm <= 8'b0000_0000;
                    // Increment hours
                    if (hh == 8'b0001_0010) begin // 12 in BCD
                        hh <= 8'b0000_0001; // Set to 1 in BCD
                        pm <= ~pm; // Toggle am/pm
                    end
                    else if (hh == 8'b0001_0001) begin // 11 in BCD
                        hh <= 8'b0001_0010; // Set to 12 in BCD
                    end
                    else begin
                        // Increment hours normally by 1
                        if (hh[3:0] == 4'b1001) begin // If units digit is 9 in BCD
                            hh <= {hh[7:4] + 1'b1, 4'b0000};
                        end
                        else begin
                            hh[3:0] <= hh[3:0] + 1'b1;
                        end
                    end
                end
                else begin
                    // Increment minutes normally by 1
                    if (mm[3:0] == 4'b1001) begin // If units digit is 9 in BCD
                        mm <= {mm[7:4] + 1'b1, 4'b0000};
                    end
                    else begin
                        mm[3:0] <= mm[3:0] + 1'b1;
                    end
                end
            end
            else begin
                // Increment seconds normally by 1
                if (ss[3:0] == 4'b1001) begin // If units digit is 9 in BCD
                    ss <= {ss[7:4] + 1'b1, 4'b0000};
                end
                else begin
                    ss[3:0] <= ss[3:0] + 1'b1;
                end
            end
        end
    end
    
endmodule