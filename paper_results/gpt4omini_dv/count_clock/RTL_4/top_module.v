module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    reg [5:0] seconds_count; // Counter for seconds (00-59)
    reg [5:0] minutes_count; // Counter for minutes (00-59)
    reg [3:0] hours_count;   // Counter for hours (01-12)

    always @(posedge clk) begin
        if (reset) begin
            ss <= 8'd0;
            mm <= 8'd0;
            hh <= 8'd12; // Start at 12:00
            pm <= 0;     // Start with AM
            seconds_count <= 0;
            minutes_count <= 0;
            hours_count <= 0;
        end else if (ena) begin
            if (seconds_count == 59) begin
                seconds_count <= 0;
                ss <= (ss + 1) % 60; // Increment seconds
                if (ss == 0) begin
                    if (minutes_count == 59) begin
                        minutes_count <= 0;
                        mm <= (mm + 1) % 60; // Increment minutes
                        if (mm == 0) begin
                            hours_count <= (hours_count == 12) ? 1 : hours_count + 1; // Increment hours
                            hh <= (hours_count == 12) ? 8'd1 : hh + 1; // Handle wrap around for 1-12
                            if (hh == 8'd12) begin
                                pm <= ~pm; // Toggle AM/PM
                            end
                        end
                    end else begin
                        minutes_count <= minutes_count + 1;
                    end
                end else begin
                    seconds_count <= seconds_count + 1;
                    ss <= seconds_count; // Keep showing seconds
                end
            end
        end
    end

endmodule