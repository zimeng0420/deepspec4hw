module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // BCD Counters
    always @(posedge clk) begin
        if (reset) begin
            hh <= 8'd12; // Reset hours to 12
            mm <= 8'd0;  // Reset minutes to 0
            ss <= 8'd0;  // Reset seconds to 0
            pm <= 1'b0;  // Reset to AM
        end else if (ena) begin
            // Seconds
            if (ss == 8'd59) begin
                ss <= 8'd0; // Reset seconds
                // Minutes
                if (mm == 8'd59) begin
                    mm <= 8'd0; // Reset minutes
                    // Hours
                    if (hh == 8'd12) begin
                        hh <= 8'd1; // Wrap around hours
                        pm <= ~pm;  // Toggle PM/AM
                    end else begin
                        hh <= hh + 8'd1; // Increment hours
                    end
                end else begin
                    mm <= mm + 8'd1; // Increment minutes
                end
            end else begin
                ss <= ss + 8'd1; // Increment seconds
            end
        end
    end
endmodule