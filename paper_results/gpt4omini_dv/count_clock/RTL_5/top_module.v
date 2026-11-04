module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    reg [5:0] seconds_count;
    reg [5:0] minutes_count;
    reg [3:0] hours_count;

    always @(posedge clk) begin
        if (reset) begin
            hh <= 8'd12;
            mm <= 8'd0;
            ss <= 8'd0;
            pm <= 0; // Start with AM
            seconds_count <= 0;
            minutes_count <= 0;
            hours_count <= 0;
        end else if (ena) begin
            // Increment seconds
            if (seconds_count == 59) begin
                seconds_count <= 0;
                ss <= ss + 1;

                // Increment minutes
                if (ss == 59) begin
                    ss <= 0;
                    if (minutes_count == 59) begin
                        minutes_count <= 0;
                        mm <= mm + 1;

                        // Increment hours
                        if (mm == 59) begin
                            mm <= 0;
                            if (hours_count == 11) begin
                                hours_count <= 0; // Reset to 1
                                hh <= 8'd1;
                                pm <= ~pm; // Toggle AM/PM
                            end else begin
                                hours_count <= hours_count + 1;
                                hh <= hh + 1;
                            end
                        end else begin
                            minutes_count <= minutes_count + 1;
                        end
                    end else begin
                        minutes_count <= minutes_count + 1;
                    end
                end else begin
                    seconds_count <= seconds_count + 1;
                    ss <= ss + 1;
                end
            end
        end
    end

endmodule