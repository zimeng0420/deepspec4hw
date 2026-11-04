module top_module(
    input clk,
    input reset,
    output [3:1] ena,
    output reg [15:0] q);

    reg ena_1, ena_2, ena_3;

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'b0;
            ena_1 <= 0;
            ena_2 <= 0;
            ena_3 <= 0;
        end else begin
            if (q[3:0] == 4'd9) begin
                q[3:0] <= 4'd0;
                ena_1 <= 1;
            end else begin
                q[3:0] <= q[3:0] + 1'b1;
                ena_1 <= 0;
            end

            if (ena_1) begin
                if (q[7:4] == 4'd9) begin
                    q[7:4] <= 4'd0;
                    ena_2 <= 1;
                end else begin
                    q[7:4] <= q[7:4] + 1'b1;
                    ena_2 <= 0;
                end
            end else begin
                ena_2 <= 0;
            end

            if (ena_2) begin
                if (q[11:8] == 4'd9) begin
                    q[11:8] <= 4'd0;
                    ena_3 <= 1;
                end else begin
                    q[11:8] <= q[11:8] + 1'b1;
                    ena_3 <= 0;
                end
            end else begin
                ena_3 <= 0;
            end
            
            if(ena_3) begin
                if (q[15:12] == 4'd9) begin
                    q[15:12] <= 4'd0;
                end else begin
                    q[15:12] <= q[15:12] + 1'b1;
                end
            end
        end
    end

    assign ena[1] = ena_1;
    assign ena[2] = ena_2;
    assign ena[3] = ena_3;

endmodule