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
            pm <= 0;           // AM
        end else if (ena) begin
            if (ss == 8'b00111001) begin // 59 in BCD
                ss <= 8'b00000000; // reset seconds to 0
                if (mm == 8'b01011001) begin // 59 in BCD
                    mm <= 8'b00000000; // reset minutes to 0
                    if (hh == 8'b00001100) begin // 12 in BCD
                        hh <= 8'b00000001; // reset hours to 1
                        pm <= ~pm; // toggle AM/PM
                    end else begin
                        hh <= hh + 1; // increment hour
                    end
                end else begin
                    mm <= mm + 1; // increment minute
                end
            end else begin
                ss <= ss + 1; // increment second
            end
        end
    end

endmodule