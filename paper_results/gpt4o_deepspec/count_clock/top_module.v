module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Internal counters for seconds, minutes, and hours
    reg [5:0] sec; // 6-bit to count 0-59
    reg [5:0] min; // 6-bit to count 0-59
    reg [4:0] hour; // 5-bit to count 1-12

    // Synchronous process
    always @(posedge clk) begin
        if (reset) begin
            // Reset all counters and outputs
            sec <= 0;
            min <= 0;
            hour <= 12; // Initialize to 12
            pm <= 0; // Start in AM
            ss <= 8'b00000000; // Seconds BCD
            mm <= 8'b00000000; // Minutes BCD
            hh <= 8'b00010010; // Hours BCD 12
        end else if (ena) begin
            // Increment seconds
            if (sec == 59) begin
                sec <= 0;
                // Increment minutes
                if (min == 59) begin
                    min <= 0;
                    // Increment hours
                    if (hour == 12) begin
                        hour <= 1; // Wrap around to 1
                        pm <= ~pm; // Toggle AM/PM
                    end else begin
                        hour <= hour + 1;
                    end
                end else begin
                    min <= min + 1;
                end
            end else begin
                sec <= sec + 1;
            end

            // Convert internal counters to BCD for outputs
            ss <= {4'b0000, sec / 10, sec % 10}; // Seconds to BCD
            mm <= {4'b0000, min / 10, min % 10}; // Minutes to BCD
            hh <= (hour == 12) ? 8'b00010010 : // BCD 12
                  {4'b0000, hour / 10, hour % 10}; // Hours to BCD
        end
    end

endmodule