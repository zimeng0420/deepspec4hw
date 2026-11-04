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
            // Reset the clock to 12:00:00 AM
            hh <= 8'b0001_0010;  // 12 in BCD
            mm <= 8'b0000_0000;  // 00 in BCD
            ss <= 8'b0000_0000;  // 00 in BCD
            pm <= 0;             // AM
        end else if (ena) begin
            // Increment seconds
            if (ss[3:0] == 4'b1001) begin
                ss[3:0] <= 4'b0000;  // Reset lower BCD digit
                if (ss[7:4] == 4'b0101) begin
                    ss[7:4] <= 4'b0000;  // Reset upper BCD digit
                    // Increment minutes
                    if (mm[3:0] == 4'b1001) begin
                        mm[3:0] <= 4'b0000;  // Reset lower BCD digit
                        if (mm[7:4] == 4'b0101) begin
                            mm[7:4] <= 4'b0000;  // Reset upper BCD digit
                            // Increment hours
                            if (hh == 8'b0001_0010) begin
                                hh <= 8'b0000_0001;  // Roll over to 01
                                pm <= ~pm;           // Toggle AM/PM
                            end else if (hh[3:0] == 4'b1001) begin
                                hh[3:0] <= 4'b0000;  // Reset lower BCD digit
                                hh[7:4] <= hh[7:4] + 1'b1;  // Increment upper BCD digit
                            end else begin
                                hh[3:0] <= hh[3:0] + 1'b1;  // Increment lower BCD digit
                            end
                        end else begin
                            mm[7:4] <= mm[7:4] + 1'b1;  // Increment upper BCD digit
                        end
                    end else begin
                        mm[3:0] <= mm[3:0] + 1'b1;  // Increment lower BCD digit
                    end
                end else begin
                    ss[7:4] <= ss[7:4] + 1'b1;  // Increment upper BCD digit
                end
            end else begin
                ss[3:0] <= ss[3:0] + 1'b1;  // Increment lower BCD digit
            end
        end
    end
endmodule