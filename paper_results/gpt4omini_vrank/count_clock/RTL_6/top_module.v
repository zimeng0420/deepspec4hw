module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    reg [3:0] sec_tenth, sec_unit; // BCD for seconds
    reg [3:0] min_tenth, min_unit; // BCD for minutes
    reg [3:0] hr_tenth, hr_unit; // BCD for hours

    always @(posedge clk) begin
        if (reset) begin
            hh <= 8'b00010000; // Set to 12:00 AM
            mm <= 8'b00000000; // Set minutes to 00
            ss <= 8'b00000000; // Set seconds to 00
            pm <= 0; // Start with AM
            hr_tenth <= 4'b0001; // 1 in BCD
            hr_unit <= 4'b0010; // 2 in BCD
        end else if (ena) begin
            if (ss == 8'b00111000) begin // 59 sec
                ss <= 8'b00000000; // Reset seconds
                if (mm == 8'b01011000) begin // 59 min
                    mm <= 8'b00000000; // Reset minutes
                    if (hr_unit == 4'b0010 && hr_tenth == 4'b0001) begin // 12:00 case
                        hr_tenth <= 4'b0001; // Reset to 1
                        hr_unit <= 4'b0001; // Set hours to 1
                        pm <= ~pm; // Toggle AM/PM
                    end else if (hr_unit == 4'b1000 && hr_tenth == 4'b0000) begin // 1:00 to 9:59
                        hr_unit <= hr_unit + 1; // Increment hour unit
                    end else if (hr_unit == 4'b0001 && hr_tenth == 4'b0001) begin // 12 case
                        hr_tenth <= 4'b0000; // Reset tens place
                        hr_unit <= 4'b0001; // Set unit to 1
                    end else begin // Regular increment
                        if (hr_unit == 4'b1000) begin // If at 10
                            hr_unit <= 4'b0000; // Reset unit
                            hr_tenth <= hr_tenth + 1; // Increment tens
                        end else begin
                            hr_unit <= hr_unit + 1; // Increment unit
                        end
                    end
                end else begin
                    mm <= mm + 1; // Increment minutes
                end
            end else begin
                ss <= ss + 1; // Increment seconds
            end
            
            // Convert BCD to hour and minute outputs
            hh <= {hr_tenth, hr_unit};
            mm <= {min_tenth, min_unit};
            ss <= {sec_tenth, sec_unit};
        end
    end

endmodule