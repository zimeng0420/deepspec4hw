module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Internal registers for seconds
    reg [3:0] ss_ones;
    reg [3:0] ss_tens;

    // Internal registers for minutes
    reg [3:0] mm_ones;
    reg [3:0] mm_tens;

    // Internal registers for hours
    reg [3:0] hh_ones;
    reg [3:0] hh_tens;

    // Auxiliary signals
    wire sec_tick;
    wire min_tick;
    wire hour_tick;


    // Seconds counter logic
    always @(posedge clk) begin
        if (reset) begin
            ss_ones <= 4'd0;
            ss_tens <= 4'd0;
        end else if (ena) begin
            if (ss_ones == 4'd9) begin
                ss_ones <= 4'd0;
                if (ss_tens == 4'd5)
                    ss_tens <= 4'd0;
                else
                    ss_tens <= ss_tens + 4'd1;
            end else
                ss_ones <= ss_ones + 4'd1;
        end
    end

    assign sec_tick = (ss_ones == 4'd9) && (ss_tens == 4'd5) && ena;

    // Minutes counter logic
    always @(posedge clk) begin
        if (reset) begin
            mm_ones <= 4'd0;
            mm_tens <= 4'd0;
        end else if (sec_tick) begin
            if (mm_ones == 4'd9) begin
                mm_ones <= 4'd0;
                if (mm_tens == 4'd5)
                    mm_tens <= 4'd0;
                else
                    mm_tens <= mm_tens + 4'd1;
            end else
                mm_ones <= mm_ones + 4'd1;
        end
    end

    assign min_tick = (mm_ones == 4'd9) && (mm_tens == 4'd5) && sec_tick;

    // Hours counter logic
    always @(posedge clk) begin
        if (reset) begin
            hh_ones <= 4'd2;
            hh_tens <= 4'd1;
            pm <= 1'b0; // AM
        end else if (min_tick) begin
            if (hh_ones == 4'd9) begin
              if(hh_tens == 4'd0) begin
                hh_ones <= 4'd0;
                hh_tens <= 4'd1;
              end else if (hh_tens == 4'd1) begin
                hh_ones <= 4'd0;
                hh_tens <= 4'd2;
                if(hh_ones == 4'd0 && hh_tens == 4'd1)
                pm <= !pm;
                else if (hh_ones == 4'd0 && hh_tens == 4'd2)
                    pm <= pm;
              end
            else
                begin
                    hh_ones <= 4'd0;
                    hh_tens <= hh_tens;
                end
            end
            else if (hh_ones == 4'd2 && hh_tens == 4'd1) begin
                hh_ones <= 4'd1;
                hh_tens <= 4'd0;
                 pm <= !pm;
            end

             else if (hh_ones == 4'd1 && hh_tens == 4'd0) begin
              hh_ones <= 4'd2;
              hh_tens <= 4'd0;
          end
          else if(hh_ones == 4'd0 && hh_tens == 4'd0) begin
                hh_ones <= 4'd1;
                hh_tens <= 4'd0;
            end


            else if (hh_ones < 4'd9)
              hh_ones <= hh_ones + 4'd1;
            else if (hh_ones == 4'd0) begin
              if(hh_tens == 4'd0) begin
              hh_ones <= 4'd1;
              hh_tens <= 4'd0;
            end
            else
              hh_ones <= hh_ones;
            end
             else if(hh_ones == 4'd9)
              begin
                hh_ones <= 4'd0;
                hh_tens <= hh_tens + 4'd0;
              end
            else
                hh_ones <= hh_ones + 4'd1;
            end
        end

    // Output assignments
    always @(*) begin
        ss = (ss_tens << 4) | ss_ones;
        mm = (mm_tens << 4) | mm_ones;
        hh = (hh_tens << 4) | hh_ones;
    end

endmodule