module top_module(
	input clk,
	input reset,
	output [3:1] ena,
	output reg [15:0] q);

    reg [3:0] ones;
    reg [3:0] tens;
    reg [3:0] hundreds;
    reg [3:0] thousands;

    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'b0000;
            tens <= 4'b0000;
            hundreds <= 4'b0000;
            thousands <= 4'b0000;
        end else begin
            // Ones digit
            if (ones == 4'b1001) begin
                ones <= 4'b0000;
            end else begin
                ones <= ones + 1;
            end

            // Tens digit
            if (ones == 4'b1001) begin
                if (tens == 4'b1001) begin
                    tens <= 4'b0000;
                end else begin
                    tens <= tens + 1;
                end
            end

            // Hundreds digit
            if (tens == 4'b1001 && ones == 4'b1001) begin
                if (hundreds == 4'b1001) begin
                    hundreds <= 4'b0000;
                end else begin
                    hundreds <= hundreds + 1;
                end
            end

            // Thousands digit
            if (hundreds == 4'b1001 && tens == 4'b1001 && ones == 4'b1001) begin
                if (thousands == 4'b1001) begin
                    thousands <= 4'b0000;
                end else begin
                    thousands <= thousands + 1;
                end
            end
        end
    end

    assign ena[1] = (ones == 4'b1001);
    assign ena[2] = (tens == 4'b1001 && ones == 4'b1001);
    assign ena[3] = (hundreds == 4'b1001 && tens == 4'b1001 && ones == 4'b1001);

    always @(*) begin
        q[3:0] = ones;
        q[7:4] = tens;
        q[11:8] = hundreds;
        q[15:12] = thousands;
    end

endmodule