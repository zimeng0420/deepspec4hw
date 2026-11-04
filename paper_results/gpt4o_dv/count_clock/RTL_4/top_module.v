module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss);

    // Internal counters for seconds, minutes, and hours
    reg [5:0] sec;
    reg [5:0] min;
    reg [4:0] hour; // 5 bits needed to count up to 12

    always @(posedge clk) begin
        if (reset) begin
            // Reset the clock to initial values
            sec <= 0;
            min <= 0;
            hour <= 12;
            pm <= 0;
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

    // BCD conversion logic
    always @* begin
        hh = {4'b0000, hour}; // Convert hour counter to BCD
        mm = {4'b0000, min};
        ss = {4'b0000, sec};
    end

endmodule