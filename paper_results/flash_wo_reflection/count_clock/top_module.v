module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [7:0] hh_next, mm_next, ss_next;
reg pm_next;

always @(posedge clk) begin
    if (reset) begin
        pm <= 0;
        hh <= 8'h12;
        mm <= 8'h00;
        ss <= 8'h00;
    end else begin
        pm <= pm_next;
        hh <= hh_next;
        mm <= mm_next;
        ss <= ss_next;
    end
end

always @(*) begin
    hh_next = hh;
    mm_next = mm;
    ss_next = ss;
    pm_next = pm;

    if (reset) begin
        pm_next = 0;
        hh_next = 8'h12;
        mm_next = 8'h00;
        ss_next = 8'h00;
    end else if (ena) begin
        // Seconds increment
        if (ss == 8'h59) begin
            ss_next = 8'h00;
            // Minutes increment
            if (mm == 8'h59) begin
                mm_next = 8'h00;
                // Hours increment
                if (hh == 8'h11) begin
                    hh_next = 8'h12;
                    pm_next = ~pm;
                } else if (hh == 8'h12) begin
                    hh_next = 8'h01;
                } else begin
                    if ((hh[3:0] == 4'd9) && (hh[7:4] < 4'd1))
                        hh_next = {hh[7:4] + 1, 4'd0};
                    else if ((hh[3:0] < 4'd9) && (hh[7:4] < 4'd1))
                        hh_next = hh + 1;
                end
            } else begin
                if ((mm[3:0] == 4'd9) && (mm[7:4] < 4'd5))
                    mm_next = {mm[7:4] + 1, 4'd0};
                else if ((mm[3:0] < 4'd9) && (mm[7:4] < 4'd5))
                    mm_next = mm + 1;
            end
        } else begin
            if ((ss[3:0] == 4'd9) && (ss[7:4] < 4'd5))
                ss_next = {ss[7:4] + 1, 4'd0};
            else if ((ss[3:0] < 4'd9) && (ss[7:4] < 4'd5))
                ss_next = ss + 1;
        end
    end
end

endmodule