module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss);

    // Internal registers for seconds, minutes, hours
    reg [5:0] sec;
    reg [5:0] min;
    reg [4:0] hour;

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00 AM
            sec <= 6'b000000;
            min <= 6'b000000;
            hour <= 5'b01100; // 12 in binary
            pm <= 0; // AM
        end
        else if (ena) begin
            // Increment seconds
            if (sec == 6'd59) begin
                sec <= 6'b000000; // Reset seconds
                // Increment minutes
                if (min == 6'd59) begin
                    min <= 6'b000000; // Reset minutes
                    // Increment hours
                    if (hour == 5'd12) begin
                        hour <= 5'b00001; // Roll over to 1
                        pm <= ~pm; // Toggle AM/PM
                    end
                    else if (hour == 5'd11) begin
                        hour <= 5'b1100; // Next is 12
                    end
                    else begin
                        hour <= hour + 1'b1; // Increment hour
                    end
                end
                else begin
                    min <= min + 1'b1; // Increment minute
                end
            end
            else begin
                sec <= sec + 1'b1; // Increment second
            end
        end
        
        // Convert binary to BCD for outputs
        hh[7:4] <= (hour > 9) ? 1 : 0;
        hh[3:0] <= (hour > 9) ? (hour - 4'd10) : hour;
        mm[7:4] <= min / 10;
        mm[3:0] <= min % 10;
        ss[7:4] <= sec / 10;
        ss[3:0] <= sec % 10;
    end

endmodule