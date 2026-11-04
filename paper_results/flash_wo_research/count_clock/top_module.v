module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [7:0] ss_next;
reg [7:0] mm_next;
reg [7:0] hh_next;
reg pm_next;

// BCD increment function
function automatic [7:0] bcd_increment (input [7:0] bcd_in);
    reg [3:0] lsb;
    reg [3:0] msb;
    
    lsb = bcd_in[3:0];
    msb = bcd_in[7:4];
    
    if (lsb == 4'b1001) begin
        lsb = 4'b0000;
        if (msb == 4'b0101) begin
            msb = 4'b0000;
        end else begin
            msb = msb + 1;
        end
    end else begin
        lsb = lsb + 1;
    end
    
    bcd_increment = {msb, lsb};
endfunction

// Next state logic (combinational)
always @(*) begin
    // Default assignments (no change)
    ss_next = ss;
    mm_next = mm;
    hh_next = hh;
    pm_next = pm;

    if (reset) begin
        ss_next = 8'b00000000; // 00
        mm_next = 8'b00000000; // 00
        hh_next = 8'b00010010; // 12
        pm_next = 1'b0;        // AM
    end else if (ena) begin
        // Seconds logic
        if (ss == 8'b01011001) begin // 59
            ss_next = 8'b00000000; // 00
            // Minutes logic
            if (mm == 8'b01011001) begin // 59
                mm_next = 8'b00000000; // 00
                // Hours logic
                if (hh == 8'b00010010) begin // 12
                    hh_next = 8'b00000001; // 01
                end else begin
                    hh_next = bcd_increment(hh);
                end

                // AM/PM logic
                if (hh == 8'b00010001) begin // 11
                    pm_next = ~pm;
                end
            end else begin
                mm_next = bcd_increment(mm);
            end
        } else begin
            ss_next = bcd_increment(ss);
        end
    end
end

// Sequential logic (registers)
always @(posedge clk) begin
    ss <= ss_next;
    mm <= mm_next;
    hh <= hh_next;
    pm <= pm_next;
end

endmodule