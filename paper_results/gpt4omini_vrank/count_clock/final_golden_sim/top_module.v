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
            hh <= 8'b00000000; // 12:00 AM in BCD
            mm <= 8'b00000000; // 00 minutes
            ss <= 8'b00000000; // 00 seconds
            pm <= 1'b0;        // AM
        end else if (ena) begin
            if (ss == 8'b01011111) begin // 59 seconds
                ss <= 8'b00000000; // Reset seconds to 0
                if (mm == 8'b00111001) begin // 59 minutes
                    mm <= 8'b00000000; // Reset minutes to 0
                    if (hh == 8'b00001001 && pm == 1'b0) begin // 12:00 AM
                        hh <= 8'b00000001; // Set to 1 (1:00 AM)
                    end else if (hh == 8'b00001001 && pm == 1'b1) begin // 12:00 PM
                        hh <= 8'b00000001; // Set to 1 (1:00 PM)
                        pm <= ~pm; // Toggle AM/PM
                    end else if (hh == 8'b00001100) begin // 12:00 PM or 12:00 AM
                        hh <= 8'b00000001; // Set to 1 (1:00)
                        pm <= ~pm; // Toggle AM/PM
                    end else begin
                        hh <= hh + 1; // Increment hour
                    end
                end else begin
                    mm <= mm + 1; // Increment minutes
                end
            end else begin
                ss <= ss + 1; // Increment seconds
            end
        end
    end

endmodule