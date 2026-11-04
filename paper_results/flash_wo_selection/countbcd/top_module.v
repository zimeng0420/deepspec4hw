module top_module(
    input clk,
    input reset,
    output [3:1] ena,
    output reg [15:0] q
);

wire eq0_1, eq1_1, eq2_1, eq3_1, equal_1;
wire eq0_2, eq1_2, eq2_2, eq3_2, equal_2;
wire eq0_3, eq1_3, eq2_3, eq3_3, equal_3;

assign eq0_1 = ~(q[0] ^ 1'b1);
assign eq1_1 = ~(q[1] ^ 1'b0);
assign eq2_1 = ~(q[2] ^ 1'b0);
assign eq3_1 = ~(q[3] ^ 1'b1);
assign equal_1 = eq0_1 & eq1_1 & eq2_1 & eq3_1;

assign eq0_2 = ~(q[4] ^ 1'b1);
assign eq1_2 = ~(q[5] ^ 1'b0);
assign eq2_2 = ~(q[6] ^ 1'b0);
assign eq3_2 = ~(q[7] ^ 1'b1);
assign equal_2 = eq0_2 & eq1_2 & eq2_2 & eq3_2;

assign eq0_3 = ~(q[8] ^ 1'b1);
assign eq1_3 = ~(q[9] ^ 1'b0);
assign eq2_3 = ~(q[10] ^ 1'b0);
assign eq3_3 = ~(q[11] ^ 1'b1);
assign equal_3 = eq0_3 & eq1_3 & eq2_3 & eq3_3;

assign ena[1] = equal_1;
assign ena[2] = equal_1 & equal_2;
assign ena[3] = equal_1 & equal_2 & equal_3;

always @(posedge clk) begin
    if (reset) begin
        q <= 16'b0;
    end else begin
        if (q[3:0] == 4'b1001) begin
            q[3:0] <= 4'b0000;
            if (q[7:4] == 4'b1001) begin
                q[7:4] <= 4'b0000;
                if (q[11:8] == 4'b1001) begin
                    q[11:8] <= 4'b0000;
                    if (q[15:12] == 4'b1001) begin
                        q[15:12] <= 4'b0000;
                    end else begin
                        q[15:12] <= q[15:12] + 1;
                    end
                end else begin
                    q[11:8] <= q[11:8] + 1;
                end
            end else begin
                q[7:4] <= q[7:4] + 1;
            end
        end else begin
            q[3:0] <= q[3:0] + 1;
        end
    end
end

endmodule