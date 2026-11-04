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
            pm   <= 1'b0;
            hh <= {4'b0001, 4'b0010};
            mm <= {4'b0000, 4'b0000};
            ss <= {4'b0000, 4'b0000};


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
                                hh_t <= 4'b0001;
                                hh_u <= 4'b0010;
                            end else if ((hh_t == 4'b0001) && (hh_u == 4'b0010)) begin
                                hh_t <= 4'b0000;
                                hh_u <= 4'b0001;
                                pm <= ~pm;
                            end else if (hh_u == 4'b1001) begin
                                hh_u <= 4'b0000;
                                hh_t <= 4'b0001;
                            }
                             else if (hh_t == 4'b0000 && hh_u == 4'b1000) begin
                                hh_u <= 4'b1001;
                            end
                            else if (hh_t == 4'b0000 && hh_u == 4'b0111) begin
                                hh_u <= 4'b1000;
                            end
                            else if (hh_t == 4'b0000 && hh_u == 4'b0110) begin
                                hh_u <= 4'b0111;
                            end
                            else if (hh_t == 4'b0000 && hh_u == 4'b0101) begin
                                hh_u <= 4'b0110;
                            end
                            else if (hh_t == 4'b0000 && hh_u == 4'b0100) begin
                                hh_u <= 4'b0101;
                            end
                            else if (hh_t == 4'b0000 && hh_u == 4'b0011) begin
                                hh_u <= 4'b0100;
                            end
                            else if (hh_t == 4'b0000 && hh_u == 4'b0010) begin
                                hh_u <= 4'b0011;
                            end
                            else if (hh_t == 4'b0000 && hh_u == 4'b0001) begin
                                hh_u <= 4'b0010;
                            end
                            else if (hh_t == 4'b0001 && hh_u == 4'b0000) begin
                                hh_u <= 4'b0001;
                            end
                            else if (hh_t == 4'b0000 && hh_u == 4'b0000) begin
                                hh_u <= 4'b0001;
                            end
                            else if (hh_t == 4'b0001 && hh_u == 4'b0001) begin
                                hh_u <= 4'b0010;
                            end

                        end else begin
                            mm_t <= mm_t + 1'b1;
                        end
                    end else begin
                        mm_u <= mm_u + 1'b1;
                    end
                end else begin
                    ss_t <= ss_t + 1'b1;
                end
            end else begin
                ss_u <= ss_u + 1'b1;
            end
        end
        hh <= {hh_t, hh_u};
        mm <= {mm_t, mm_u};
        ss <= {ss_t, ss_u};
    end

endmodule