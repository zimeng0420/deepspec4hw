module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg seconds_carry_out;
reg minutes_carry_out;

always @(posedge clk) begin
    if (reset) begin
        hh <= 8'b00010010; // 12
        mm <= 8'b00000000; // 00
        ss <= 8'b00000000; // 00
        pm <= 1'b0;       // AM
    end else begin
        if (ena) begin
            // Seconds
            if (ss == 8'b01011001) begin // 59
                ss <= 8'b00000000; // 00
                seconds_carry_out <= 1'b1;
            end else begin
                ss <= bcd_add(ss, 8'b00000001);
                seconds_carry_out <= 1'b0;
            end

            // Minutes
            if (seconds_carry_out) begin
                if (mm == 8'b01011001) begin // 59
                    mm <= 8'b00000000; // 00
                    minutes_carry_out <= 1'b1;
                end else begin
                    mm <= bcd_add(mm, 8'b00000001);
                    minutes_carry_out <= 1'b0;
                end
            end else begin
                minutes_carry_out <= 1'b0;
            end

            // Hours
            if (minutes_carry_out) begin
                if (hh == 8'b00010010) begin // 12
                    hh <= 8'b00000001; // 01
                end else begin
                    hh <= bcd_add(hh, 8'b00000001);
                end
            end

            // AM/PM
            if (minutes_carry_out && hh == 8'b00010001) begin // Transition from 11 to 12
                pm <= ~pm;
            end
        end
    end
end

// BCD addition function
function [7:0] bcd_add;
    input [7:0] a, b;
    reg [7:0] sum;
    reg carry;

    begin
        sum = a + b;
        carry = 1'b0;

        if ((sum[3:0] > 4'b1001) ) begin
            sum[3:0] = sum[3:0] + 4'b0110;
        end

        if ((sum[7:4] > 4'b1001)) begin
            sum[7:4] = sum[7:4] + 4'b0110;
        end

        if (sum > 8'b10011001) begin
            sum = sum + 8'b01100110;
        end

        bcd_add = sum;
    end
endfunction

endmodule