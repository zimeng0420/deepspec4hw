module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss);

    // Internal registers for binary counters
    reg [5:0] sec;   // second counter [0-59]
    reg [5:0] min;   // minute counter [0-59]
    reg [4:0] hour;  // hour counter [1-12]
    
    always @(posedge clk) begin
        if (reset) begin
            // Reset state
            sec <= 0;
            min <= 0;
            hour <= 12;
            pm <= 0; // AM
        end
        else if (ena) begin
            // Increment seconds
            if (sec == 59) begin
                sec <= 0;
                // Increment minutes
                if (min == 59) begin
                    min <= 0;
                    // Increment hours
                    if (hour == 12) begin
                        hour <= 1;
                        pm <= ~pm; // Toggle AM/PM
                    end
                    else begin
                        hour <= hour + 1;
                    end
                end
                else begin
                    min <= min + 1;
                end
            end
            else begin
                sec <= sec + 1;
            end
        end
    end

    // Convert binary to BCD for output
    always @* begin
        hh = {4'b0000, hour}; // Direct assignment (hour is already BCD compatible)
        mm = {(min/10), (min%10)};
        ss = {(sec/10), (sec%10)};
    end
endmodule