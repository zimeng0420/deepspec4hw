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
            hh <= 8'b0001_0010; // 12
            mm <= 8'b0000_0000; // 00
            ss <= 8'b0000_0000; // 00
            pm <= 0;
        end else if (ena) begin
            // Increment seconds
            if (ss[3:0] == 4'b1001) begin
                ss[3:0] <= 4'b0000;
                if (ss[7:4] == 4'b0101) begin
                    ss[7:4] <= 4'b0000;

                    // Increment minutes
                    if (mm[3:0] == 4'b1001) begin
                        mm[3:0] <= 4'b0000;
                        if (mm[7:4] == 4'b0101) begin
                            mm[7:4] <= 4'b0000;

                            // Increment hours
                            if (hh[3:0] == 4'b1001) begin
                                hh[3:0] <= 4'b0000;
                                if (hh[7:4] == 4'b0001 && hh[3:0] == 4'b0010) begin
                                    hh <= 8'b0001_0001; // 11 to 12
                                    pm <= ~pm; // Toggle AM/PM at 12
                                end else if (hh[7:4] == 4'b0001) begin
                                    hh <= 8'b0000_0001; // 10 to 11
                                end else begin
                                    hh[7:4] <= hh[7:4] + 1;
                                end
                            end else begin
                                hh[3:0] <= hh[3:0] + 1;
                            end
                            // Handle 01 (AM) and 12 (PM) equal case
                            if (hh == 8'b0000_0001 && pm == 1'b1) begin
                                pm <= ~pm; // Toggle at 1 o'clock
                            end
                        end else begin
                            mm[7:4] <= mm[7:4] + 1;
                        end
                    end else begin
                        mm[3:0] <= mm[3:0] + 1;
                    end
                end else begin
                    ss[7:4] <= ss[7:4] + 1;
                end
            end else begin
                ss[3:0] <= ss[3:0] + 1;
            end
        end
    end
endmodule