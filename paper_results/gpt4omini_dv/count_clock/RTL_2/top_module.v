module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    reg [5:0] sec_count = 0;
    reg [5:0] min_count = 0;
    reg [3:0] hour_count = 0;

    always @(posedge clk) begin
        if (reset) begin
            hh <= 8'd12;
            mm <= 8'd0;
            ss <= 8'd0;
            pm <= 0;
            sec_count <= 0;
            min_count <= 0;
            hour_count <= 0;
        end else if (ena) begin
            if (sec_count == 59) begin
                sec_count <= 0;
                ss <= ss + 1;
                if (ss == 59) begin
                    ss <= 0;
                    min_count <= min_count + 1;
                    if (min_count == 59) begin
                        min_count <= 0;
                        hour_count <= hour_count + 1;
                        if (hour_count == 12) begin
                            pm <= ~pm;
                        end
                        if (hour_count == 12) begin
                            hour_count <= 1;
                        end
                        hh <= (hour_count == 0) ? 8'd1 : {4'b0000, hour_count}; // Convert to 8-bit BCD
                    end
                    mm <= {4'b0000, min_count}; // Convert to 8-bit BCD
                end
            end else begin
                sec_count <= sec_count + 1;
                ss <= {4'b0000, sec_count}; // Convert to 8-bit BCD
            end
        end
    end
endmodule