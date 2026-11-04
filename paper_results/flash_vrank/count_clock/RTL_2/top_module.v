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
            sec_ones <= 4'b0000;
            sec_tens <= 3'b000;
            min_ones <= 4'b0000;
            min_tens <= 3'b000;
            hour_ones <= 4'b0010;
            hour_tens <= 4'b0001;
            pm <= 0;
            ss <= 8'h00;
            mm <= 8'h00;
            hh <= 8'h12;
        end else if (ena) begin
            // Seconds
            if (sec_ones == 4'b1001) begin
                sec_ones <= 4'b0000;
                if (sec_tens == 3'b0101) begin
                    sec_tens <= 3'b000;
                    // Minutes
                    if (min_ones == 4'b1001) begin
                        min_ones <= 4'b0000;
                        if (min_tens == 3'b0101) begin
                            min_tens <= 3'b000;
                            // Hours
                            if ((hour_tens == 4'b0001) && (hour_ones == 4'b0010)) begin
                                hour_tens <= 4'b0000;
                                hour_ones <= 4'b0001;
                                pm <= ~pm;
                            end else begin
                                if (hour_ones == 4'b1001) begin
                                    hour_ones <= 4'b0000;
                                    hour_tens <= hour_tens + 1'b1;
                                end else begin
                                    hour_ones <= hour_ones + 1'b1;
                                end
                            end
                        end else begin
                            min_tens <= min_tens + 1'b1;
                        end
                    end else begin
                        min_ones <= min_ones + 1'b1;
                    end
                end else begin
                    sec_tens <= sec_tens + 1'b1;
                end
            end else begin
                sec_ones <= sec_ones + 1'b1;
            end
        end

        // Assign outputs
        ss <= {sec_tens, sec_ones};
        mm <= {min_tens, min_ones};
        hh <= {hour_tens, hour_ones};

        //Special case when hour becomes 13, it should be 1.
        if({hour_tens, hour_ones} == 4'b00011011)
            begin
                hour_tens <= 4'b0000;
                hour_ones <= 4'b0001;
            end
    end

endmodule