module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
    );

    // Initialize registers
    reg [3:0] hh_ones, hh_tens, mm_ones, mm_tens, ss_ones, ss_tens;

    // Combinational logic to decode hours into hh
    always @* begin
        hh = {hh_tens, hh_ones};
    end

    // Combinational logic to decode minutes into mm
    always @* begin
        mm = {mm_tens, mm_ones};
    end

    // Combinational logic to decode seconds into ss
    always @* begin
        ss = {ss_tens, ss_ones};
    end

    // Synchronous logic to manage the time
    always @(posedge clk) begin
        if (reset) begin
            // Reset all time counters
            ss_ones <= 4'd0;
            ss_tens <= 4'd0;
            mm_ones <= 4'd0;
            mm_tens <= 4'd0;
            hh_ones <= 4'd2;
            hh_tens <= 4'd1;
            pm <= 1'b0; // AM
        end 
        else if (ena) begin
            // Increment seconds
            if (ss_ones == 4'd9) begin
                ss_ones <= 4'd0;
                if (ss_tens == 4'd5) begin
                    ss_tens <= 4'd0;
                    
                    // Increment minutes
                    if (mm_ones == 4'd9) begin
                        mm_ones <= 4'd0;
                        if (mm_tens == 4'd5) begin
                            mm_tens <= 4'd0;
                            
                            // Increment hours
                            if (hh_ones == 4'd9 || hh_ones == 4'd2 && hh_tens == 4'd1) begin
                                hh_ones <= 4'd0;
                                
                                if (hh_tens == 4'd0) begin
                                    hh_tens <= 4'd1;
                                end else begin
                                    hh_tens <= 4'd0;
                                    pm <= ~pm; // Toggle AM/PM
                                end
                            end else begin
                                hh_ones <= hh_ones + 1;
                            end
                        end else begin
                            mm_tens <= mm_tens + 1;
                        end
                    end else begin
                        mm_ones <= mm_ones + 1;
                    end
                end else begin
                    ss_tens <= ss_tens + 1;
                end
            end else begin
                ss_ones <= ss_ones + 1;
            end
        end
    end

endmodule