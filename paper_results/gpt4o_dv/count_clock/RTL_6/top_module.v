module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss);

    reg [3:0] sec_ones, sec_tens;
    reg [3:0] min_ones, min_tens;
    reg [3:0] hour_ones, hour_tens;

    // Helper task to handle BCD incrementation
    task increment_bcd;
        input [3:0] current_ones, current_tens;
        input [3:0] max_ones;
        output [3:0] next_ones, next_tens;
        output carry_out;
        
        begin
            if (current_ones == max_ones) begin
                next_ones = 4'd0;
                if (current_tens == 4'd5) begin
                    next_tens = 4'd0;
                    carry_out = 1'b1;
                end else begin
                    next_tens = current_tens + 4'd1;
                    carry_out = 1'b0;
                end
            end else begin
                next_ones = current_ones + 4'd1;
                next_tens = current_tens;
                carry_out = 1'b0;
            end
        end
    endtask

    always @(posedge clk) begin
        if (reset) begin
            sec_ones <= 4'd0;
            sec_tens <= 4'd0;
            min_ones <= 4'd0;
            min_tens <= 4'd0;
            hour_ones <= 4'd2; // 12 in BCD: tens=1, ones=2
            hour_tens <= 4'd1;
            pm <= 1'b0;
        end else if (ena) begin
            // Seconds incrementation
            increment_bcd(sec_ones, sec_tens, 4'd9, sec_ones, sec_tens, carry);
            if (carry) begin
                // Minutes incrementation
                increment_bcd(min_ones, min_tens, 4'd9, min_ones, min_tens, carry);
                if (carry) begin
                    // Hours incrementation
                    if (hour_ones == 4'd2 && hour_tens == 4'd1) begin
                        hour_ones <= 4'd1; // from 12 to 01
                        hour_tens <= 4'd0;
                        pm <= ~pm; // toggle AM/PM
                    end else
                        increment_bcd(hour_ones, hour_tens, 4'd9, hour_ones, hour_tens, carry);
                end
            end
        end

        // Updating BCD outputs
        ss <= {sec_tens, sec_ones}; // BCD for seconds
        mm <= {min_tens, min_ones}; // BCD for minutes
        hh <= {hour_tens, hour_ones}; // BCD for hours
    end
endmodule