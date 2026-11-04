module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss);

    always @(posedge clk) begin
        if (reset) begin
            hh <= 8'b00010010; // 12
            mm <= 8'b00000000; // 00
            ss <= 8'b00000000; // 00
            pm <= 1'b0;        // AM
        end else if (ena) begin
            // Increment seconds
            if (ss[3:0] == 4'b1001) begin // If sec low digit is 9
                ss[3:0] <= 4'b0000;
                if (ss[7:4] == 4'b0101) begin // If sec high digit is 5
                    ss[7:4] <= 4'b0000;
                    
                    // Increment minutes
                    if (mm[3:0] == 4'b1001) begin // If min low digit is 9
                        mm[3:0] <= 4'b0000;
                        if (mm[7:4] == 4'b0101) begin // If min high digit is 5
                            mm[7:4] <= 4'b0000;
                            
                            // Increment hours
                            if (hh[3:0] == 4'b1001 || (hh[7:4] == 4'b0001 && hh[3:0] == 4'b0010)) begin
                                hh[3:0] <= 4'b0000;
                                hh[7:4] <= 4'b0001 - hh[7:4]; // Toggle between 10 and 0
                                pm <= ~pm; // Toggle AM/PM
                            end else begin
                                hh[3:0] <= hh[3:0] + 4'b0001;
                            end
                        end else begin
                            mm[7:4] <= mm[7:4] + 4'b0001;
                        end
                    end else begin
                        mm[3:0] <= mm[3:0] + 4'b0001;
                    end
                end else begin
                    ss[7:4] <= ss[7:4] + 4'b0001;
                end
            end else begin
                ss[3:0] <= ss[3:0] + 4'b0001;
            end
        end
    end

endmodule