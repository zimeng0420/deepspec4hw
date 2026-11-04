module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    reg [5:0] count;  // Counter for clock ticks

    always @(posedge clk) begin
        if (reset) begin
            hh <= 8'b0001_0010; // Reset to 12 in BCD
            mm <= 8'b0000_0000; // Reset to 00 in BCD
            ss <= 8'b0000_0000; // Reset to 00 in BCD
            pm <= 0;            // Reset to AM
            count <= 0;        // Reset counter
        end else begin
            // Count only when enabled
            if (ena) begin
                count <= count + 1;

                // If count reaches 59 (which means 1 second has passed)
                if (count == 59) begin
                    count <= 0; // Reset count

                    // Increment seconds
                    if (ss == 8'b0000_0000 + 8'b0000_0011) begin
                        ss <= 8'b0000_0000; // reset seconds to 0
                        // Increment minutes
                        if (mm == 8'b0000_0101_1001) begin // 59 in BCD
                            mm <= 8'b0000_0000; // reset minutes to 0
                            // Increment hours
                            if (hh == 8'b0001_0010) begin // 12 in BCD
                                hh <= 8'b0000_0001; // reset to 01
                                pm <= ~pm; // Toggle AM/PM
                            end else begin
                                hh <= hh + 1; // increment hour
                            end
                        end else begin
                            mm <= mm + 1; // increment minute
                        end
                    end else begin
                        ss <= ss + 1; // increment seconds
                    end
                end
            end
        end
    end
endmodule