module top_module(
    input clk,
    input reset,
    output [3:1] ena,
    output reg [15:0] q);

    reg ena1, ena2, ena3;

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'b0;
            ena1 <= 1'b0;
            ena2 <= 1'b0;
            ena3 <= 1'b0;
        end else begin
            // Ones digit
            if (q[3:0] == 4'd9) begin
                q[3:0] <= 4'd0;
                ena1 <= 1'b1;
            } else begin
                q[3:0] <= q[3:0] + 1'b1;
                ena1 <= 1'b0;
            end

            // Tens digit
            if (ena1) begin
                if (q[7:4] == 4'd9) begin
                    q[7:4] <= 4'd0;
                    ena2 <= 1'b1;
                } else begin
                    q[7:4] <= q[7:4] + 1'b1;
                    ena2 <= 1'b0;
                end
            } else begin
                ena2 <= 1'b0;
            end

            // Hundreds digit
            if (ena2) begin
                if (q[11:8] == 4'd9) begin
                    q[11:8] <= 4'd0;
                    ena3 <= 1'b1;
                } else begin
                    q[11:8] <= q[11:8] + 1'b1;
                    ena3 <= 1'b0;
                end
            } else begin
                ena3 <= 1'b0;
            end

            // Thousands digit
            if (ena3) begin
                if (q[15:12] == 4'd9) begin
                    q[15:12] <= 4'd0;
                } else begin
                    q[15:12] <= q[15:12] + 1'b1;
                end
            end
        end
    end

    assign ena[1] = ena1;
    assign ena[2] = ena2;
    assign ena[3] = ena3;

endmodule