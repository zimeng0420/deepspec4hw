module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss);

    reg [3:0] sec_ones;
    reg [2:0] sec_tens;
    reg [3:0] min_ones;
    reg [2:0] min_tens;
    reg [3:0] hour_ones;
    reg [3:0] hour_tens;

    always @(posedge clk) begin
        if (reset) begin
            sec_ones <= 4'd0;
            sec_tens <= 3'd0;
            min_ones <= 4'd0;
            min_tens <= 3'd0;
            hour_ones <= 4'd2;
            hour_tens <= 4'd1;
            pm <= 0;
            ss <= 8'h00;
            mm <= 8'h00;
            hh <= 8'h12;
        end else if (ena) begin
            // Seconds
            if (sec_ones == 4'd9) begin
                sec_ones <= 4'd0;
                if (sec_tens == 3'd5) begin
                    sec_tens <= 3'd0;
                    // Minutes
                    if (min_ones == 4'd9) begin
                        min_ones <= 4'd0;
                        if (min_tens == 3'd5) begin
                            min_tens <= 3'd0;
                            // Hours
                            if ((hour_tens == 4'd0) && (hour_ones == 4'd9)) begin
                                hour_ones <= 4'd1;
                                hour_tens <= 4'd1;
                            end else if ((hour_tens == 4'd1) && (hour_ones == 4'd1)) begin
                                hour_ones <= 4'd2;
                                hour_tens <= 4'd0;
                            end else if ((hour_tens == 4'd1) && (hour_ones == 4'd2)) begin
                                hour_ones <= 4'd1;
                                hour_tens <= 4'd0;
                                pm <= ~pm;
                            end else begin
                                hour_ones <= hour_ones + 4'd1;
                            end
                        end else begin
                            min_tens <= min_tens + 3'd1;
                        end
                    end else begin
                        min_ones <= min_ones + 4'd1;
                    end
                end else begin
                    sec_tens <= sec_tens + 3'd1;
                end
            end else begin
                sec_ones <= sec_ones + 4'd1;
            end
        end
        ss <= {sec_tens, sec_ones};
        mm <= {min_tens, min_ones};
        hh <= {hour_tens, hour_ones};
    end

endmodule