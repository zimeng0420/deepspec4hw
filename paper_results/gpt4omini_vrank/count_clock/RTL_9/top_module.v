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
            hh <= 8'b00010000; // 12 in BCD
            mm <= 8'b00000000; // 0 in BCD
            ss <= 8'b00000000; // 0 in BCD
            pm <= 0; // AM
        end else if (ena) begin
            if (ss == 8'b01011000) begin // 59 in BCD
                ss <= 8'b00000000; // Reset seconds
                if (mm == 8'b01011000) begin // 59 in BCD
                    mm <= 8'b00000000; // Reset minutes
                    if (hh == 8'b00010000) begin // 12 in BCD
                        hh <= 8'b00000001; // Reset to 1 in BCD
                        pm <= ~pm; // Toggle PM/AM
                    end else begin
                        hh <= hh + 1; // Increment hours
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