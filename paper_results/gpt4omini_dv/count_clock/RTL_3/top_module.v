module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    reg [3:0] sec, min, hour;

    always @(posedge clk) begin
        if (reset) begin
            hh <= 8'd12;  // Reset to 12
            mm <= 8'd0;   // Reset minutes to 00
            ss <= 8'd0;   // Reset seconds to 00
            pm <= 1'b0;   // Reset to AM
            hour <= 4'd12; // BCD for hour 12
        end else if (ena) begin
            // Increment seconds
            if (ss == 8'd59) begin
                ss <= 8'd0;  // Reset seconds
                if (min == 8'd59) begin
                    min <= 8'd0; // Reset minutes
                    hour <= (hour == 4'd12) ? 4'd1 : hour + 4'd1; // Increment hour
                    if (hour == 4'd12) begin
                        pm <= ~pm; // Toggle PM/AM
                    end
                end else begin
                    min <= min + 8'd1; // Increment minutes
                end
            end else begin
                ss <= ss + 8'd1; // Increment seconds
            end
            
            // Update hh in BCD
            hh <= {4'b0000, hour}; // Update hh with hour in BCD format
        end
    end
endmodule