module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    reg [5:0] sec_count;
    reg [5:0] min_count;
    reg [3:0] hr_count;

    always @(posedge clk) begin
        if (reset) begin
            hh <= 8'b00001100; // Reset to "12"
            mm <= 8'b00000000; // Reset to "00"
            ss <= 8'b00000000; // Reset to "00"
            pm <= 1'b0;        // Reset to "AM"
            sec_count <= 6'b000000; // Reset sec_count
            min_count <= 6'b000000; // Reset min_count
            hr_count <= 4'b0000;     // Reset hr_count
        end else if (ena) begin
            if (sec_count == 6'b001110) begin // 60 seconds
                sec_count <= 6'b000000; // Reset seconds
                if (min_count == 6'b111011) begin // 60 minutes
                    min_count <= 6'b000000; // Reset minutes
                    hr_count <= hr_count + 1; // Increment hours

                    if (hr_count == 4'b1010) begin // 12 hours
                        hr_count <= 4'b0000; // Reset hours
                        pm <= ~pm; // Toggle AM/PM
                    end
                end else begin
                    min_count <= min_count + 1; // Increment minutes
                end
            end else begin
                sec_count <= sec_count + 1; // Increment seconds
            end

            // BCD Conversion
            hh <= {4'b0000, hr_count}; // Assign hour in BCD
            mm <= {4'b0000, min_count}; // Assign minute in BCD
            ss <= {4'b0000, sec_count}; // Assign second in BCD
        end
    end
endmodule