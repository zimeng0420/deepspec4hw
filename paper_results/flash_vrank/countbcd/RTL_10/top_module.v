module top_module(
    input clk,
    input reset,
    output [3:1] ena,
    output reg [15:0] q);

    reg ena1, ena2, ena3;

    always @(posedge clk) begin
        if (reset) begin
            q <= 0;
            ena1 <= 0;
            ena2 <= 0;
            ena3 <= 0;
        end else begin
            ena1 <= 0;
            ena2 <= 0;
            ena3 <= 0;

            if (q[3:0] == 9) begin
                q[3:0] <= 0;
                ena1 <= 1;
                if (q[7:4] == 9) begin
                    q[7:4] <= 0;
                    ena2 <= 1;
                    if (q[11:8] == 9) begin
                        q[11:8] <= 0;
                        ena3 <= 1;
                        if (q[15:12] == 9) begin
                            q[15:12] <= 0;
                        end else begin
                            q[15:12] <= q[15:12] + 1;
                        end
                    end else begin
                        q[11:8] <= q[11:8] + 1;
                    end
                end else begin
                    q[7:4] <= q[7:4] + 1;
                end
            } else begin
                q[3:0] <= q[3:0] + 1;
            end
        end
    end

    assign ena[1] = ena1;
    assign ena[2] = ena2;
    assign ena[3] = ena3;

endmodule