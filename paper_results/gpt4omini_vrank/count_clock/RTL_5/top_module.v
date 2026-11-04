module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss);

    reg [6:0] count; // To count seconds

    always @(posedge clk) begin
        if (reset) begin
            hh <= 8'b00001100; // Reset to 12
            mm <= 8'b00000000; // Reset minutes to 00
            ss <= 8'b00000000; // Reset seconds to 00
            pm <= 0;           // Reset to AM
            count <= 0;       // Reset second counter
        end else if (ena) begin
            if (count == 59) begin
                count <= 0;
                if (ss == 59) begin
                    ss <= 0;
                    if (mm == 59) begin
                        mm <= 0;
                        if (hh == 8'b00001100) begin // If hour is 12
                            pm <= ~pm; // Toggle PM/AM
                        end
                        if (hh == 8'b00001010) // If hour is 10
                            hh <= hh + 2; // Set to 12
                        else
                            hh <= hh + 1; // Increment hour
                    end else begin
                        mm <= mm + 1; // Increment minute
                    end
                end else begin
                    ss <= ss + 1; // Increment second
                end
            end else begin
                count <= count + 1; // Count seconds
            end
        end
    end
endmodule