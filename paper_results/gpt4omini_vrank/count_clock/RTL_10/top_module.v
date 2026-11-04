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
            hh <= 8'b00001100; // 12 in BCD
            mm <= 8'b00000000; // 00 in BCD
            ss <= 8'b00000000; // 00 in BCD
            pm <= 1'b0;        // AM
        end else if (ena) begin
            if (ss == 8'b01011001) begin // 59 in BCD
                ss <= 8'b00000000; // Reset seconds
                if (mm == 8'b01011001) begin // 59 in BCD
                    mm <= 8'b00000000; // Reset minutes
                    if (hh == 8'b00001100) begin // 12 in BCD
                        hh <= 8'b00001101; // Set to 1 in BCD for PM
                        pm <= ~pm;    // Toggle AM/PM
                    end else if (hh == 8'b00001101) begin // 1 in BCD
                        hh <= 8'b00001110; // Set to 2 in BCD
                    end else if (hh == 8'b00001110) begin // 2 in BCD
                        hh <= 8'b00001111; // Set to 3 in BCD
                    end else if (hh == 8'b00001111) begin // 3 in BCD
                        hh <= 8'b00010000; // Set to 4 in BCD
                    end else if (hh == 8'b00010000) begin // 4 in BCD
                        hh <= 8'b00010001; // Set to 5 in BCD
                    end else if (hh == 8'b00010001) begin // 5 in BCD
                        hh <= 8'b00010010; // Set to 6 in BCD
                    end else if (hh == 8'b00010010) begin // 6 in BCD
                        hh <= 8'b00010011; // Set to 7 in BCD
                    end else if (hh == 8'b00010011) begin // 7 in BCD
                        hh <= 8'b00010100; // Set to 8 in BCD
                    end else if (hh == 8'b00010100) begin // 8 in BCD
                        hh <= 8'b00010101; // Set to 9 in BCD
                    end else if (hh == 8'b00010101) begin // 9 in BCD
                        hh <= 8'b00010110; // Set to 10 in BCD
                    end else if (hh == 8'b00010110) begin // 10 in BCD
                        hh <= 8'b00010111; // Set to 11 in BCD
                    end else if (hh == 8'b00010111) begin // 11 in BCD
                        hh <= 8'b00001100; // Set back to 12 in BCD
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