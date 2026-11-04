module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Helper function to update BCD counters
    function automatic [7:0] bcd_increment;
        input [7:0] bcd_value;
        input [7:0] max_value;
        begin
            if (bcd_value[3:0] == 4'd9) begin
                if (bcd_value[7:4] == max_value[7:4] - 1) begin
                    bcd_increment = 8'd0;
                end else begin
                    bcd_increment = {bcd_value[7:4] + 1, 4'd0}; // carry over
                end
            end else begin
                bcd_increment = bcd_value + 8'd1;
            end
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            hh <= 8'h12; // "12" in BCD
            mm <= 8'h00; // "00" in BCD
            ss <= 8'h00; // "00" in BCD
            pm <= 0;     // AM
        end else if (ena) begin
            // Increment seconds
            ss <= bcd_increment(ss, 8'h60);
            
            // If seconds overflow, increment minutes
            if (ss == 8'h59) begin
                mm <= bcd_increment(mm, 8'h60);
                ss <= 8'h00;
            end
            
            // If minutes overflow, increment hours
            if (mm == 8'h59 && ss == 8'h59) begin
                mm <= 8'h00;
                hh <= (hh == 8'h12) ? 8'h01 : bcd_increment(hh, 8'h13);
                
                // Toggle AM/PM at 12:00
                if (hh == 8'h12) begin
                    pm <= ~pm;
                end
            end
        end
    end
endmodule