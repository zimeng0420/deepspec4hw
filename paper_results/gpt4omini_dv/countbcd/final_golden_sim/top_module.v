module top_module(
    input clk,
    input reset,
    output [3:1] ena,
    output reg [15:0] q
);

    wire [3:0] ones = q[3:0];
    wire [3:0] tens = q[7:4];
    wire [3:0] hundreds = q[11:8];
    wire [3:0] thousands = q[15:12];

    assign ena[1] = (ones == 4'd9);
    assign ena[2] = (tens == 4'd9 && ena[1]);
    assign ena[3] = (hundreds == 4'd9 && ena[2]);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 16'b0;
        end else begin
            if (ones == 4'd9) begin
                q[3:0] <= 4'b0000;
                if (ena[1]) begin
                    if (tens == 4'd9) begin
                        q[7:4] <= 4'b0000;
                        if (ena[2]) begin
                            if (hundreds == 4'd9) begin
                                q[11:8] <= 4'b0000;
                                if (ena[3]) begin
                                    q[15:12] <= q[15:12] + 1'b1;
                                end else begin
                                    q[15:12] <= q[15:12];
                                end
                            end else begin
                                q[11:8] <= hundreds + 1'b1;
                            end
                        end else begin
                            q[7:4] <= tens + 1'b1;
                        end
                    end else begin
                        q[7:4] <= tens + 1'b1;
                    end
                end else begin
                    q[3:0] <= ones + 1'b1;
                end
            end else begin
                q[3:0] <= ones + 1'b1;
            end
        end
    end
endmodule