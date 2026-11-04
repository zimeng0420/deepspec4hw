module top_module(
    input clk,
    input reset,
    output [3:1] ena,
    output reg [15:0] q
);

reg ena1, ena2, ena3;

always @(posedge clk) begin
    if (reset) begin
        q <= 16'h0000;
        ena1 <= 0;
        ena2 <= 0;
        ena3 <= 0;
    end else begin
        if (q[3:0] == 4'b1001) begin
            q[3:0] <= 4'b0000;
            ena1 <= 1;
            if (q[7:4] == 4'b1001) begin
                q[7:4] <= 4'b0000;
                ena2 <= 1;
                if (q[11:8] == 4'b1001) begin
                    q[11:8] <= 4'b0000;
                    ena3 <= 1;
                    if (q[15:12] == 4'b1001) begin
                        q[15:12] <= 4'b0000;
                    end else begin
                        q[15:12] <= q[15:12] + 4'b0001;
                    end
                    ena3 <= 0;
                end else begin
                    q[11:8] <= q[11:8] + 4'b0001;
                    ena3 <= 0;
                end
                ena2 <= 0;
            end else begin
                q[7:4] <= q[7:4] + 4'b0001;
                ena2 <= 0;
            end
            ena1 <= 0;
        end else begin
            q[3:0] <= q[3:0] + 4'b0001;
            ena1 <= 0;
            ena2 <= 0;
            ena3 <= 0;
        end
    end
end

assign ena[1] = ena1;
assign ena[2] = ena2;
assign ena[3] = ena3;


endmodule