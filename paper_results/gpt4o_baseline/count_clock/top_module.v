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
            // Reset the clock to 12:00 AM
            hh <= 8'b00010010; // 12 in BCD
            mm <= 8'b00000000; // 00 in BCD
            ss <= 8'b00000000; // 00 in BCD
            pm <= 0; // AM
        end else if (ena) begin
            // Increment the seconds (00-59)
            if (ss[3:0] == 4'd9) begin
                if (ss[7:4] == 4'd5) begin
                    ss <= 8'b00000000; // Reset seconds
                    // Increment the minutes (00-59)
                    if (mm[3:0] == 4'd9) begin
                        if (mm[7:4] == 4'd5) begin
                            mm <= 8'b00000000; // Reset minutes
                            // Increment the hours (01-12)
                            if (hh[3:0] == 4'd9) begin
                                if (hh[7:4] == 4'd1) begin
                                    hh <= 8'b00000001; // Wrap from 12 to 1
                                    pm <= ~pm; // Toggle PM/AM
                                end else begin
                                    hh[7:4] <= hh[7:4] + 1; // Increment tens place of hours
                                    hh[3:0] <= 4'd0; // Reset ones place of hours
                                end
                            end else if (hh[3:0] == 4'd2 && hh[7:4] == 4'd1) begin
                                hh <= 8'b00000001; // Wrap from 12 to 1
                                pm <= ~pm; // Toggle PM/AM
                            end else begin
                                hh[3:0] <= hh[3:0] + 1; // Increment ones place of hours
                            end
                        end else begin
                            mm[7:4] <= mm[7:4] + 1; // Increment tens place of minutes
                            mm[3:0] <= 4'd0; // Reset ones place of minutes
                        end
                    end else begin
                        mm[3:0] <= mm[3:0] + 1; // Increment ones place of minutes
                    end
                end else begin
                    ss[7:4] <= ss[7:4] + 1; // Increment tens place of seconds
                    ss[3:0] <= 4'd0; // Reset ones place of seconds
                end
            end else begin
                ss[3:0] <= ss[3:0] + 1; // Increment ones place of seconds
            end
        end
    end

endmodule