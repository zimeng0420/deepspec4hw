module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    reg [3:0] sec_ones, sec_tens;
    reg [3:0] min_ones, min_tens;
    reg [3:0] hour_ones, hour_tens;
    
    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            sec_ones <= 4'd0;
            sec_tens <= 4'd0;
            min_ones <= 4'd0;
            min_tens <= 4'd0;
            hour_ones <= 4'd2;   // 12 in BCD is 12 (tens 4'd1, ones 4'd2)
            hour_tens <= 4'd1;
            pm <= 1'b0;          // AM
        end else if (ena) begin
            // Increment seconds
            if (sec_ones == 4'd9) begin
                sec_ones <= 4'd0;
                if (sec_tens == 4'd5) begin
                    sec_tens <= 4'd0;
                    // Increment minutes
                    if (min_ones == 4'd9) begin
                        min_ones <= 4'd0;
                        if (min_tens == 4'd5) begin
                            min_tens <= 4'd0;
                            // Increment hours
                            if (hour_ones == 4'd9) begin
                                hour_ones <= 4'd0;
                                if (hour_tens == 4'd1) begin
                                    hour_tens <= 4'd0;
                                    hour_ones <= 4'd1; // Go to 01 from 12
                                    pm <= ~pm;        // toggle AM/PM
                                end else begin
                                    hour_tens <= hour_tens + 1;
                                end
                            end else if (hour_ones == 4'd2 && hour_tens == 4'd1) begin
                                hour_ones <= 4'd1; // Go to 01 from 12
                                hour_tens <= 4'd0;
                                pm <= ~pm;        // toggle AM/PM
                            end else begin
                                hour_ones <= hour_ones + 1;
                            end
                        end else begin
                            min_tens <= min_tens + 1;
                        end
                    end else begin
                        min_ones <= min_ones + 1;
                    end
                end else begin
                    sec_tens <= sec_tens + 1;
                end
            end else begin
                sec_ones <= sec_ones + 1;
            end
        end
    end

    // Assign outputs
    assign ss = {sec_tens, sec_ones};
    assign mm = {min_tens, min_ones};
    assign hh = {hour_tens, hour_ones};

endmodule