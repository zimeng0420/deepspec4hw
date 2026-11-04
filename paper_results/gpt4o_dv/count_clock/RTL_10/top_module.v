module top_module(
	input clk,
	input reset,
	input ena,
	output reg pm,
	output reg [7:0] hh,
	output reg [7:0] mm,
	output reg [7:0] ss);

    // Internal registers for binary counters
    reg [5:0] sec, min;
    reg [3:0] hour;

    always @(posedge clk) begin
        if (reset) begin
            // Reset logic: initialize counters and outputs to 12:00 AM
            sec <= 6'd0;
            min <= 6'd0;
            hour <= 4'd12;
            pm <= 1'b0; // AM
            ss <= 8'b00000000;
            mm <= 8'b00000000;
            hh <= 8'b00010010; // 12 BCD
        end else if (ena) begin
            // Increment seconds
            if (sec == 6'd59) begin
                sec <= 6'd0;
                // Increment minutes
                if (min == 6'd59) begin
                    min <= 6'd0;
                    // Increment hours
                    if (hour == 4'd12) begin
                        hour <= 4'd1;
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
            
            // Convert binary counters to BCD outputs
            ss <= {4'd0, sec[3:0]} + 8'd10 * sec[5:4];
            mm <= {4'd0, min[3:0]} + 8'd10 * min[5:4];
            if (hour == 4'd12)
                hh <= 8'b00010010; // BCD for 12
            else
                hh <= {4'd0, hour[3:0]} + 8'd10 * hour[3:0] / 10;
        end
    end

endmodule