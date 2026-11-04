module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    reg [3:0] ss_u; // Seconds units digit
    reg [3:0] ss_t; // Seconds tens digit
    reg [3:0] mm_u; // Minutes units digit
    reg [3:0] mm_t; // Minutes tens digit
    reg [3:0] hh_u; // Hours units digit
    reg [3:0] hh_t; // Hours tens digit

    always @(posedge clk) begin
        if (reset) begin
            ss_u <= 4'b0000;
            ss_t <= 4'b0000;
            mm_u <= 4'b0000;
            mm_t <= 4'b0000;
            hh_u <= 4'b0010;
            hh_t <= 4'b0001;
            pm <= 0;
        end else if (ena) begin
            // Seconds
            if (ss_u == 4'b1001) begin
                ss_u <= 4'b0000;
                if (ss_t == 4'b0101) begin
                    ss_t <= 4'b0000;

                    // Minutes
                    if (mm_u == 4'b1001) begin
                        mm_u <= 4'b0000;
                        if (mm_t == 4'b0101) begin
                            mm_t <= 4'b0000;

                            // Hours
                            if ((hh_t == 4'b0001) && (hh_u == 4'b0001)) begin
                                hh_u <= 4'b0010;
                                hh_t <= 4'b0001;
                            end else if ((hh_t == 4'b0001) && (hh_u == 4'b0010)) begin
                                hh_u <= 4'b0001;
                                hh_t <= 4'b0000;
                                pm <= ~pm;
                            end else if (hh_u == 4'b1001) begin
                                hh_u <= 4'b0000;
                                hh_t <= hh_t + 4'b0001; // should go to 10, handled below
                            end
                             else if ((hh_t == 4'b0001) && (hh_u == 4'b0000)) begin
                                hh_t <= 4'b0001;
                                hh_u <= 4'b0001;
                            end
                            else begin
                                hh_u <= hh_u + 4'b0001;
                            end
                        end else begin
                            mm_t <= mm_t + 4'b0001;
                        end
                    end else begin
                        mm_u <= mm_u + 4'b0001;
                    end
                end else begin
                    ss_t <= ss_t + 4'b0001;
                end
            } else begin
                ss_u <= ss_u + 4'b0001;
            end
        end
    end

    always @(*) begin
        ss = {ss_t, ss_u};
        mm = {mm_t, mm_u};
        hh = {hh_t, hh_u};
    end

endmodule