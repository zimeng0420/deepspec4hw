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
                            if (hh_u == 4'b0001 && hh_t == 4'b0001) begin //11
                                hh_u <= 4'b0010;
                                hh_t <= 4'b0001; // 12
                                pm <= ~pm;
                            } else if (hh_u == 4'b0010 && hh_t == 4'b0001) begin //12
                                hh_u <= 4'b0001;
                                hh_t <= 4'b0000; //01
                            }
                            else if (hh_u == 4'b1001 && hh_t == 4'b0000) begin //09
                                hh_u <= 4'b0000;
                                hh_t <= 4'b0001; // 10
                            }
                            else if (hh_u == 4'b0000 && hh_t == 4'b0001) begin //10
                                hh_u <= 4'b0001;
                                hh_t <= 4'b0001; // 11
                            }
                            else begin
                                if(hh_u == 4'b0009) begin
                                    hh_u <= 4'b0000;
                                    hh_t <= 4'b0000;

                                } else begin
                                    hh_u <= hh_u + 4'b0001;

                                end
                            end
                        end else begin
                            mm_t <= mm_t + 4'b0001;
                        end
                    } else begin
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