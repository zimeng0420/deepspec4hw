module top_module(
    input clk,
    input reset,
    output [3:1] ena,
    output reg [15:0] q
);

reg [3:0] ones, tens, hundreds, thousands;

assign ena[1] = (ones == 4'd9);
assign ena[2] = (ones == 4'd9) & (tens == 4'd9);
assign ena[3] = (ones == 4'd9) & (tens == 4'd9) & (hundreds == 4'd9);

always @(posedge clk) begin
    if (reset) begin
        ones <= 4'd0;
        tens <= 4'd0;
        hundreds <= 4'd0;
        thousands <= 4'd0;
    end else begin
        if (ones == 4'd9) begin
            ones <= 4'd0;
            if (tens == 4'd9) begin
                tens <= 4'd0;
                if (hundreds == 4'd9) begin
                    hundreds <= 4'd0;
                    if (thousands == 4'd9) begin
                        thousands <= 4'd0;
                    end else begin
                        thousands <= thousands + 4'd1;
                    end
                end else begin
                    hundreds <= hundreds + 4'd1;
                end
            end else begin
                tens <= tens + 4'd1;
            end
        end else begin
            ones <= ones + 4'd1;
        end
    end
end

always @(*) begin
    q[3:0] = ones;
    q[7:4] = tens;
    q[11:8] = hundreds;
    q[15:12] = thousands;
end

endmodule