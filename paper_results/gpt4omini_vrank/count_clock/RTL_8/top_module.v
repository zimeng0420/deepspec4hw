module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // BCD counters with enable and reset
    always @(posedge clk) begin
        if (reset) begin
            hh <= 8'b00001100; // Reset to 12
            mm <= 8'b00000000; // Reset to 00
            ss <= 8'b00000000; // Reset to 00
            pm <= 0;           // Reset to AM
        end else if (ena) begin
            // Manage seconds
            if (ss == 59) begin
                ss <= 0;
                // Manage minutes
                if (mm == 59) begin
                    mm <= 0;
                    // Manage hours
                    if (hh == 8'b00001100) begin // If hour is 12
                        hh <= 8'b00000001; // Set to 1
                        pm <= ~pm; // Toggle AM/PM
                    end else begin
                        hh <= hh + 1; // Increment hour
                    end
                end else begin
                    mm <= mm + 1; // Increment minute
                end
            end else begin
                ss <= ss + 1; // Increment second
            end
        end
    end
endmodule