module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss);

    // Internal wires to handle the BCD counting for each digit
    wire [3:0] seg_second_ones, seg_second_tens;
    wire [3:0] seg_minute_ones, seg_minute_tens;
    wire [3:0] seg_hour_ones, seg_hour_tens;

    // Count seconds
    always @(posedge clk) begin
        if (reset) begin
            ss <= 8'h00;
        end else if (ena) begin
            if (ss == 8'h59) begin
                ss <= 8'h00;
            end else if (ss[3:0] == 4'd9) begin
                ss[3:0] <= 4'd0;
                ss[7:4] <= ss[7:4] + 1;
            end else begin
                ss <= ss + 1;
            end
        end
    end

    // Count minutes
    always @(posedge clk) begin
        if (reset) begin
            mm <= 8'h00;
        end else if (ena && ss == 8'h59) begin
            if (mm == 8'h59) begin
                mm <= 8'h00;
            end else if (mm[3:0] == 4'd9) begin
                mm[3:0] <= 4'd0;
                mm[7:4] <= mm[7:4] + 1;
            end else begin
                mm <= mm + 1;
            end
        end
    end

    // Count hours
    always @(posedge clk) begin
        if (reset) begin
            hh <= 8'h12;
            pm <= 1'b0;
        end else if (ena && ss == 8'h59 && mm == 8'h59) begin
            if (hh == 8'h12) begin
                hh <= 8'h01;
                pm <= ~pm;
            end else if (hh == 8'h11) begin
                hh <= 8'h12;
            end else if (hh[3:0] == 4'd9) begin
                hh <= {hh[7:4] + 1, 4'd0};
            end else begin
                hh <= hh + 1;
            end
        end
    end

endmodule