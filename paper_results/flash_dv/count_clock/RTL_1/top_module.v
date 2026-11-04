module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Helper function to increment a BCD digit
    function automatic [3:0] bcd_increment (input [3:0] digit);
        if (digit == 4'h9) begin
            bcd_increment = 4'h0;
        end else begin
            bcd_increment = digit + 1'b1;
        end
    endfunction

    // Helper function to determine carry-out from BCD increment
    function automatic carry_out (input [3:0] digit);
        carry_out = (digit == 4'h9);
    endfunction
    
    reg carry_sec;
    reg carry_min;

    always @(posedge clk) begin
        if (reset) begin
            ss <= 8'h00;
            mm <= 8'h00;
            hh <= 8'h12;
            pm <= 0;
        end else if (ena) begin
            // Seconds
            if (ss[3:0] == 4'h9) begin
                if (ss[7:4] == 4'h5) begin
                    ss <= 8'h00;
                    carry_sec <= 1'b1;
                end else begin
                    ss <= {ss[7:4] + 1'b1, 4'h0};
                    carry_sec <= 1'b0;
                end
            } else begin
                ss <= {ss[7:4], bcd_increment(ss[3:0])};
                carry_sec <= 1'b0;
            end

            // Minutes
            if (carry_sec) begin
                if (mm[3:0] == 4'h9) begin
                    if (mm[7:4] == 4'h5) begin
                        mm <= 8'h00;
                        carry_min <= 1'b1;
                    end else begin
                        mm <= {mm[7:4] + 1'b1, 4'h0};
                        carry_min <= 1'b0;
                    end
                } else begin
                    mm <= {mm[7:4], bcd_increment(mm[3:0])};
                    carry_min <= 1'b0;
                end
            end else begin
                carry_min <= 1'b0;
            end

            // Hours
            if (carry_min) begin
                if (hh == 8'h11) begin
                    hh <= 8'h12;
                end else if (hh == 8'h12) begin
                    hh <= 8'h01;
                    pm <= ~pm;
                end else if (hh[3:0] == 4'h9) begin
                    hh <= {4'h1, 4'h0};
                }
                else if (hh[7:4] == 4'h0) begin
                    if (hh[3:0] == 4'h0) begin
                        hh <= 8'h01;
                    } else begin
                        hh <= {hh[7:4], bcd_increment(hh[3:0])};
                    end
                } else begin
                    hh <= {hh[7:4], bcd_increment(hh[3:0])};
                end
            end
        end
    end

endmodule