module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    reg [3:0] ss_u, ss_t, mm_u, mm_t, hh_u, hh_t;

    always @(posedge clk) begin
        if (reset) begin
            ss <= 8'h00;
            mm <= 8'h00;
            hh <= 8'h12;
            pm <= 0;

            ss_u <= 4'h0;
            ss_t <= 4'h0;
            mm_u <= 4'h0;
            mm_t <= 4'h0;
            hh_u <= 4'h2;
            hh_t <= 4'h1;

        end else if (ena) begin
            // Seconds
            if (ss_u == 4'h9) begin
                ss_u <= 4'h0;
                if (ss_t == 4'h5) begin
                    ss_t <= 4'h0;
                    ss <= 8'h00;

                    // Minutes
                    if (mm_u == 4'h9) begin
                        mm_u <= 4'h0;
                        if (mm_t == 4'h5) begin
                            mm_t <= 4'h0;
                            mm <= 8'h00;

                            // Hours
                            if (hh == 8'h11) begin
                                hh <= 8'h12;
                                hh_u <= 4'h2;
                                hh_t <= 4'h1;
                                pm <= ~pm;
                            } else if (hh == 8'h12) begin
                                hh <= 8'h01;
                                hh_u <= 4'h1;
                                hh_t <= 4'h0;
                            } else begin
                                if (hh_u == 4'h9) begin
                                    hh_u <= 4'h0;
                                    hh_t <= hh_t + 1;
                                    hh <= {hh_t, hh_u};
                                } else if (hh_t == 4'h0) begin
                                    hh_u <= hh_u + 1;
                                    hh <= {hh_t, hh_u};
                                }
                            end
                        end else begin
                            mm_t <= mm_t + 1;
                            mm <= {mm_t, mm_u};
                        end
                    end else begin
                        mm_u <= mm_u + 1;
                        mm <= {mm_t, mm_u};
                    end
                end else begin
                    ss_t <= ss_t + 1;
                    ss <= {ss_t, ss_u};
                end
            } else begin
                ss_u <= ss_u + 1;
                ss <= {ss_t, ss_u};
            end
        end
    end

endmodule