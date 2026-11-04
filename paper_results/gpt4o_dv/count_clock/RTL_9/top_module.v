module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss);

    // Internal registers to store current time
    reg [5:0] sec;
    reg [5:0] min;
    reg [3:0] hour;

    // Helper function to convert binary to BCD
    function [7:0] binary_to_bcd;
        input [5:0] binary;
        integer i;
        reg [7:0] bcd;
        begin
            bcd = 8'd0;
            for (i = 0; i < 6; i = i + 1) begin
                bcd = {bcd[6:0], binary[5-i]};
                if (i < 5 && bcd[3:0] > 4) bcd[3:0] = bcd[3:0] + 3;
                if (i < 5 && bcd[7:4] > 4) bcd[7:4] = bcd[7:4] + 3;
            end
            binary_to_bcd = bcd;
        end
    endfunction

    // Sequential logic to update time
    always @(posedge clk) begin
        if (reset) begin
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
                    else if (hour == 11) begin
                        hour <= 12;
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
    always @(*) begin
        ss = binary_to_bcd(sec);
        mm = binary_to_bcd(min);
        hh = binary_to_bcd({2'b00, hour});
    end

endmodule