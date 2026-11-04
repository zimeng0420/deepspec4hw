module top_module (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    always @(posedge clk) begin
        if (reset) begin
            hh <= 8'd1;    // Reset hours to 01
            mm <= 8'd0;    // Reset minutes to 00
            ss <= 8'd0;    // Reset seconds to 00
            pm <= 1'b0;    // Reset to AM
        end else if (ena) begin
            if (ss < 8'd59) begin
                ss <= ss + 8'd1; // Increment seconds
            end else begin
                ss <= 8'd0; // Reset seconds
                if (mm < 8'd59) begin
                    mm <= mm + 8'd1; // Increment minutes
                end else begin
                    mm <= 8'd0; // Reset minutes
                    if (hh < 8'd12) begin
                        hh <= hh + 8'd1; // Increment hours
                    end else begin
                        hh <= 8'd1; // Reset hours to 01 after 12
                        pm <= ~pm; // Toggle AM/PM
                    end
                end
            end
        end
    end

endmodule