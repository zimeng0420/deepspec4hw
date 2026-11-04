module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg sec_carry;
reg min_carry;

// BCD increment function
function automatic reg [3:0] bcd_increment(input reg [3:0] in);
    if (in == 4'h9)
        bcd_increment = 4'h0;
    else
        bcd_increment = in + 1'b1;
endfunction

always @(posedge clk) begin
    if (reset) begin
        ss <= 8'h00;
        mm <= 8'h00;
        hh <= 8'h12;
        pm <= 0;
        sec_carry <= 0;
        min_carry <= 0;
    end else if (ena) begin
        // Seconds
        if (ss[3:0] == 4'h9) begin
            if (ss[7:4] == 4'h5) begin
                ss <= 8'h00;
                sec_carry <= 1;
            end else begin
                ss <= {ss[7:4] + 1'b1, 4'h0};
                sec_carry <= 0;
            end
        } else begin
            ss <= {ss[7:4], bcd_increment(ss[3:0])};
            sec_carry <= 0;
        end

        // Minutes
        if (sec_carry) begin
            if (mm[3:0] == 4'h9) begin
                if (mm[7:4] == 4'h5) begin
                    mm <= 8'h00;
                    min_carry <= 1;
                end else begin
                    mm <= {mm[7:4] + 1'b1, 4'h0};
                    min_carry <= 0;
                end
            } else begin
                mm <= {mm[7:4], bcd_increment(mm[3:0])};
                min_carry <= 0;
            end
        end else begin
            min_carry <= 0;
        end

        // Hours
        if (min_carry) begin
            if (hh == 8'h11) begin
                hh <= 8'h12;
            end else if (hh == 8'h12) begin
                hh <= 8'h01;
                pm <= ~pm;
            end else if (hh[3:0] == 4'h9) begin
                hh <= {4'h1, 4'h0};
            }
            else if (hh[7:4] == 4'h0)
            begin
                hh <= {hh[7:4], bcd_increment(hh[3:0])};
            end
            else
            begin
                hh <= {hh[7:4], bcd_increment(hh[3:0])};
            end
        end
    end
end

endmodule